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
import io
import base64
import logging

logger = logging.getLogger(__name__)

genai.configure(api_key=settings.GEMINI_API_KEY)
model = genai.GenerativeModel("gemini-pro")
chat = model.start_chat(history=[])

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