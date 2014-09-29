FROM jphager2/rubydev:onbuild 

ENV RUBYLIB /usr/src/app/lib 

RUN mkdir /home/manga 

WORKDIR /home/manga
