from django.urls import path
from .views import RecordAudioView, ProcessAudioView, YorubaToEnglishView, LlamaYorubaToEnglishView, CameraView

urlpatterns = [
    path('record/', RecordAudioView.as_view(), name='record_audio'),
    path('process/', ProcessAudioView.as_view(), name='process_audio'),
    path('translate-yoruba/', YorubaToEnglishView.as_view(), name='yoruba_to_english'),
    path('llama-translate-yoruba/', LlamaYorubaToEnglishView.as_view(), name='yoruba_to_english'),
    path('process-image/', CameraView.as_view(), name='process_image'),
]