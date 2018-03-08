FROM mandrx/azure-iot-sdk-python-arm 
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ubuntu-raspi2/ppa
RUN apt-get update
RUN apt-get -y install libraspberrypi-dev
RUN apt-get install git
RUN apt-get install -y bison libasound2-dev swig
COPY aliases.txt /lib/modprobe.d/aliases.conf
RUN apt-get -y install python3-pip
ENV PYTHON /usr/bin/python3
RUN git clone --recursive https://github.com/bambocher/pocketsphinx-python
WORKDIR ./pocketsphinx-python
RUN rm README.rst
RUN touch README.rst
RUN apt-get install -qq python python-dev python-pip build-essential swig git libpulse-dev
RUN python3 setup.py build
RUN python3 setup.py install
RUN pip3 install SpeechRecognition
WORKDIR /azure-iot-sdk-python/device/samples
COPY *.py ./ 
RUN  apt-get install -y portaudio19-dev
RUN pip3 install pyaudio
RUN apt-get install vim alsa-utils
CMD /bin/bash