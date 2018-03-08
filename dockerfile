FROM mandrx/azure-iot-sdk-python-arm 
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ubuntu-raspi2/ppa
RUN apt-get update
RUN apt-get -y install libraspberrypi-dev
RUN apt-get install wget
RUN wget https://sourceforge.net/projects/cmusphinx/files/sphinxbase/5prealpha/sphinxbase-5prealpha.tar.gz/download -O sphinxbase.tar.gz
RUN wget https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/pocketsphinx-5prealpha.tar.gz/download -O pocketsphinx.tar.gz
RUN tar -xzvf sphinxbase.tar.gz
RUN tar -xzvf pocketsphinx.tar.gz
RUN apt-get install -y bison libasound2-dev swig
COPY aliases.txt /lib/modprobe.d/aliases.conf
RUN apt-get -y install python3-pip
ENV PYTHON /usr/bin/python3
WORKDIR sphinxbase-5prealpha
RUN ./configure --enable-fixed
RUN make
RUN make install
WORKDIR ../pocketsphinx-5prealpha
RUN ./configure
RUN make
RUN make install
RUN cp -a /usr/local/lib/python3.5/site-packages/sphinxbase/. /usr/lib/python3.5
RUN cp -a /usr/local/lib/python3.5/site-packages/pocketsphinx/. /usr/lib/python3.5
RUN pip3 install SpeechRecognition
WORKDIR /azure-iot-sdk-python/device/samples
COPY *.py ./ 
RUN  apt-get install -y portaudio19-dev
RUN pip3 install pyaudio
CMD /bin/bash