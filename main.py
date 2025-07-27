from apscheduler.schedulers.background import BackgroundScheduler
import time
from plyer import notification
from gtts import gTTS
import os

def notify(message):
    notification.notify(
        title="my personal assistant",
        message= message,
        app_name="Personal Assistant",
        timeout=10 
    )
    tts = gTTS(message, lang="en", tld="co.uk")
    tts.save("voice.mp3")
    os.system("mpg123 voice.mp3")

def drink_water_reminder():
    print("starting the drink water reminder")
    notify("Drink water now")

schedular = BackgroundScheduler()
schedular.add_job(drink_water_reminder, 'interval', minutes=60)
schedular.start()

while True:
    time.sleep(1)