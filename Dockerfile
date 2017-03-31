FROM anapsix/alpine-java:8_jdk


# adapted from comics/samtools:
ENV SAMTOOLS_VERSION=1.3.1
ENV BBTOOLS_VERSION=37.02

RUN mkdir /samtools/

RUN apk update

RUN apk add ca-certificates wget \
&& update-ca-certificates \
&& apk add tar \
&& apk add gzip \
&& apk add gcc \
&& apk add libgcc \
&& apk add g++ \
&& apk add ncurses-dev \
&& apk add make

RUN apk add --update zlib-dev \
&& apk add --update ncurses-libs \
&& apk add --update git

ENV LIBRARY_PATH=/lib:/usr/lib

# downloading samtools...
RUN cd /samtools/ \
&& wget --no-check-certificate https://sourceforge.net/projects/samtools/files/samtools/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 \
&& wget --no-check-certificate https://sourceforge.net/projects/samtools/files/samtools/${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION}.tar.bz2 \
&& wget --no-check-certificate https://sourceforge.net/projects/samtools/files/samtools/${SAMTOOLS_VERSION}/bcftools-${SAMTOOLS_VERSION}.tar.bz2

# unpacking samtools...
RUN cd /samtools/ \
&& tar xvf samtools-${SAMTOOLS_VERSION}.tar.bz2 \
&& tar xvf htslib-${SAMTOOLS_VERSION}.tar.bz2 \
&& tar xvf bcftools-${SAMTOOLS_VERSION}.tar.bz2

# compiling...
# samtools:
RUN cd /samtools/samtools-${SAMTOOLS_VERSION}/ \
&&  ./configure \
&&  make \
&&  make prefix=/samtools/samtools/ install
ENV PATH=/samtools/samtools/bin:$PATH 

# bcftools:
RUN cd /samtools/bcftools-${SAMTOOLS_VERSION}/ \
&&  make \
&&  make prefix=/samtools/bcftools/ install
ENV PATH=/samtools/bcftools/bin:$PATH

# htslib:
RUN cd /samtools/htslib-${SAMTOOLS_VERSION}/ \
&&  make \
&&  make prefix=/samtools/htslib/ install 
ENV PATH=/samtools/htslib/bin:$PATH

RUN mkdir /bbtools/ \
&&  cd /bbtools/ \
&&  wget --no-check-certificate https://sourceforge.net/projects/bbmap/files/BBMap_${BBTOOLS_VERSION}.tar.gz \
&&  tar xzvf BBMap_${BBTOOLS_VERSION}.tar.gz
ENV PATH=/bbtools/bbmap/:$PATH

# directories that input/output can be directed to:
RUN mkdir /input/ \
&&  mkdir /output/


