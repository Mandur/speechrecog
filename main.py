from sender import Sender

import sys
sys.path.append('/usr/local/lib/python3.5/site-packages/sphinxbase')
sys.path.append('/usr/local/lib/python3.5/site-packages/pocketsphinx')
import pocketsphinx
import speech_recognition as sr


def main():
    CONNECTION_STRING = os.getenv('EdgeHubConnectionString')
    CA_CERTIFICATE = os.getenv('EdgeModuleCACertificateFile', False)
    sender = Sender(CONNECTION_STRING, CA_CERTIFICATE)
    print("connected to "+CONNECTION_STRING)
    global r
    r = sr.Recognizer()
    with sr.Microphone() as source:
        while True:
            # obtain audio from the microphone  
            print("Say something!")
            audio = r.listen(source)

            # recognize speech using Sphinx
            try:
                if sender:
                    msg_properties = {
                        'detection_index': str(detection_index)
                    }
                    json_formatted = json.dumps({"text":r.recognize_sphinx(audio)})
                    sender.send_event_to_output(json_formatted, msg_properties, detection_index)
                    print("Sphinx thinks you said " + r.recognize_sphinx(audio))
            except sr.UnknownValueError:
                print("Sphinx could not understand audio")
            except sr.RequestError as e:
                print("Sphinx error; {0}".format(e))


main()