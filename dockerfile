FROM mandrx/azure-iot-sdk-python-arm 
RUN apt-get install wget
RUN wget https://sourceforge.net/projects/cmusphinx/files/sphinxbase/5prealpha/sphinxbase-5prealpha.tar.gz/download -O sphinxbase.tar.gz
RUN wget https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/pocketsphinx-5prealpha.tar.gz/download -O pocketsphinx.tar.gz
RUN tar -xzvf sphinxbase.tar.gz
RUN tar -xzvf pocketsphinx.tar.gz
RUN apt-get install -y bison libasound2-dev swig
COPY aliases.txt /lib/modprobe.d/aliases.conf
RUN rm -f /usr/bin/python && ln -s /usr/bin/python /usr/bin/python3
ENV PYTHON python
ENV PYTHON_VERSION 3.5
WORKDIR sphinxbase-5prealpha
RUN ./configure --enable-fixed
RUN make
RUN make install
WORKDIR ../pocketsphinx-5prealpha
RUN ./configure
RUN make
RUN make install
RUN apt-get -y install python3-pip
RUN pip3 install SpeechRecognition
WORKDIR ..
COPY *.py ./ 
RUN  apt-get install -y portaudio19-dev
RUN pip3 install pyaudio
CMD /bin/bash