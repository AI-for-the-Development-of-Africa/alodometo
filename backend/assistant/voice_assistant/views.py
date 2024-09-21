# In your Django project, install the required package:
# pip install gTTS

from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import google.generativeai as genai
from django.conf import settings
import speech_recognition as sr
from pydub import AudioSegment
from gtts import gTTS
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from PIL import Image
import pytesseract
import google.generativeai as genai
from django.conf import settings
import io
import base64
import logging
import re
import json
import requests

# import JsonResponse

logger = logging.getLogger(__name__)

genai.configure(api_key=settings.GEMINI_API_KEY)
model = genai.GenerativeModel("gemini-pro")
chat = model.start_chat(history=[])

# use of llama
LLAMA_API_URL = "http://localhost:11434/api/chat"


class RecordAudioView(APIView):
    def post(self, request):
        audio_file = request.FILES.get('audio')
        if audio_file:
            try:
                logger.info(f"Received audio file of size {audio_file.size} bytes")
                audio_data = audio_file.read()
                audio = AudioSegment.from_file(io.BytesIO(audio_data), format="m4a")
                wav_data = io.BytesIO()
                audio.export(wav_data, format="wav")
                wav_data.seek(0)
                
                recognizer = sr.Recognizer()
                with sr.AudioFile(wav_data) as source:
                    audio = recognizer.record(source)
                
                text = recognizer.recognize_google(audio)
                logger.info(f"Recognized text: {text}")
                return Response({'success': True, 'text': text})
            except Exception as e:
                logger.error(f"Error processing audio: {str(e)}", exc_info=True)
                return Response({'success': False, 'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
        logger.warning("No audio file provided")
        return Response({'success': False, 'error': 'No audio file provided'}, status=status.HTTP_400_BAD_REQUEST)

class ProcessAudioView(APIView):
    def post(self, request):
        text = request.data.get('text')
        if text:
            try:
                logger.info(f"Processing text: {text}")
                response = chat.send_message(text)
                logger.info(f"AI response: {response.text}")
                
                # Convert AI response to speech
                tts = gTTS(response.text, lang='en')
                audio_io = io.BytesIO()
                tts.write_to_fp(audio_io)
                audio_io.seek(0)
                audio_data = audio_io.read()
                audio_base64 = base64.b64encode(audio_data).decode('utf-8')
                
                return Response({
                    'success': True, 
                    'response': response.text, 
                    'audio': audio_base64
                })
            except Exception as e:
                logger.error(f"Error processing text: {str(e)}", exc_info=True)
                return Response({'success': False, 'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
        logger.warning("No text provided")
        return Response({'success': False, 'error': 'No text provided'}, status=status.HTTP_400_BAD_REQUEST)
    

class YorubaToEnglishView(APIView):
    def post(self, request):
        data = json.loads(request.body)
        yoruba_text = data.get('text')

        if not yoruba_text:
            return Response({'success': False, 'error': 'No text provided'}, status=400)
        # yoruba_text = request.data.get('text')
        # if not yoruba_text:
        #     logger.warning("No Yoruba text provided")
        #     return Response({'success': False, 'error': 'No text provided'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            logger.info(f"Translating Yoruba text: {yoruba_text}")
            
            system_instruction = """
            You are an API. Logically transcribe the text written in Yoruba into English and give it to me in dict format 
            as well as its translation text in Yoruba { text: ...., trans: ...... }. 
            Return only the dict without anything else. 
            Example: output = { language: ...., text: ...., text_translate: ...... }
            """
            
            prompt_parts = [system_instruction, yoruba_text]
            response = model.generate_content(prompt_parts)
            
            extracted_json = re.search(r'\{(.+?)\}', response.text, re.DOTALL)
            if extracted_json:
                extracted_dict = json.loads(extracted_json.group(0))
                print(extracted_dict)
                english_translation = extracted_dict.get("trans", "Translation not found")
                # english_translation = f"Translation of: {yoruba_text}"
                logger.info(f"English translation: {english_translation}")
                return Response({
                    'success': True,
                    'yoruba_text': yoruba_text,
                    'english_translation': english_translation
                })
            else:
                logger.warning("Failed to extract translation")
                return Response({'success': False, 'error': 'Failed to extract translation'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        except Exception as e:
            logger.error(f"Error translating Yoruba text: {str(e)}", exc_info=True)
            return Response({'success': False, 'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class LlamaYorubaToEnglishView(APIView):
    def post(self, request):
        data = json.loads(request.body)
        yoruba_text = data.get('text')
        if not yoruba_text:
            return Response({'success': False, 'error': 'No text provided'}, status=400)

        try:
            logger.info(f"Translating Yoruba text: {yoruba_text}")
            
            system_instruction = """
            You are an API. Logically transcribe the text written in Yoruba into English and give it to me in dict format
            as well as its translation text in Yoruba { text: ...., trans: ...... }.
            Return only the dict without anything else.
            Example: output = { language: ...., text: ...., text_translate: ...... }
            """
            
            prompt = f"{system_instruction}\n\n{yoruba_text}"
            
            payload = {
                "model": "llama3.1",
                "messages": [
                    {"role": "user", "content": prompt}
                ]
            }
            
            response = requests.post(LLAMA_API_URL, json=payload)
            response.raise_for_status()
            
            # Process the streaming response
            full_response = ""
            for line in response.iter_lines():
                if line:
                    json_response = json.loads(line)
                    if json_response.get("done"):
                        break
                    content = json_response.get("message", {}).get("content", "")
                    full_response += content

            # Extract the JSON from the full response
            extracted_dict = json.loads(full_response)
            
            english_translation = extracted_dict.get("trans", "Translation not found")
            
            logger.info(f"English translation: {english_translation}")
            return Response({
                'success': True,
                'yoruba_text': yoruba_text,
                'english_translation': english_translation
            })
        
        except Exception as e:
            logger.error(f"Error translating Yoruba text: {str(e)}", exc_info=True)
            return Response({'success': False, 'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



class CameraView(APIView):
    @csrf_exempt
    def post(self, request):
        if 'image' not in request.FILES:
            return Response({'error': 'No image file provided'}, status=status.HTTP_400_BAD_REQUEST)

        image_file = request.FILES['image']
        
        try:
            # Extract text from image
            image = Image.open(image_file)
            logger.info("Image opened successfully")
            extracted_text = pytesseract.image_to_string(image)
            logger.info(f"Extracted text: {extracted_text}")
            print(extracted_text)

            # Translate text (assuming it's in Yoruba)
            prompt = f"Translate this English text to Yoruba: {extracted_text}"
            response = model.generate_content(prompt)
            print(response)
            translated_text = response.text
            logger.info(f"Translated text: {translated_text}")
            print(translated_text)
            # Convert translated text to speech
            tts = gTTS(translated_text, lang='en')
            audio_io = io.BytesIO()
            tts.write_to_fp(audio_io)
            audio_io.seek(0)
            audio_data = audio_io.read()
            audio_base64 = base64.b64encode(audio_data).decode('utf-8')
            logger.info("Audio generated successfully")

            return Response({
                'success': True,
                'extractedText': extracted_text,
                'translatedText': translated_text,
                'audioUrl': f"data:audio/mp3;base64,{audio_base64}"
            })
        except Exception as e:
            logger.error(f"Error processing image: {str(e)}", exc_info=True)
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)