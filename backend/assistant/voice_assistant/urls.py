from django.urls import path
from .views import RecordAudioView, ProcessAudioView, YorubaToEnglishView

urlpatterns = [
    path('record/', RecordAudioView.as_view(), name='record_audio'),
    path('process/', ProcessAudioView.as_view(), name='process_audio'),
    path('translate-yoruba/', YorubaToEnglishView.as_view(), name='yoruba_to_english'),
]