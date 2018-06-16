FROM ubuntu:16.04
COPY ./sources.list /etc/apt/sources.list
WORKDIR /home/
RUN apt-get -qq update &&\
    apt-get -qq --yes install curl &&\
    apt-get install sudo --yes &&\
    adduser --disabled-password --gecos "" shiny && gpasswd -a shiny sudo && \
    echo 'debconf debconf/frontend select Noninteractive' --yes | debconf-set-selections &&\
    sudo apt install curl wget apt-transport-https dirmngr --yes


COPY ./secondSourcesList.list /etc/apt/sources.list

RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN sudo apt-get update -y && apt-get -y upgrade
RUN  sudo touch ./dependencies.sh && sudo chown shiny:shiny ./dependencies.sh && sudo chmod +xrw ./dependencies.sh

RUN ./dependencies.sh

RUN sudo apt-get update -y
RUN sudo apt-get install r-base -y
RUN sudo apt-get install r-base-dev -y

RUN  sudo apt install dirmngr
RUN  apt-get install -y apt-utils



RUN mkdir /home/RLibz
RUN R -e ".libPaths('/home/RLibz/')" 
COPY ./Renviron /etc/R/Renviron
COPY ./Renviron.site /etc/R/Renviron.site





RUN sudo touch ./packageInstaller.R

### DO NO MODIFY ANYTHING ABOVE THIS LINE
ARG DEBIAN_FRONTED=noninteractive
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 && gpg -a --export E084DAB9 | sudo apt-key add -




RUN sudo apt-get update -y && sudo apt-get install gdebi-core -y && sudo apt-get install build-essential && sudo apt-key update




RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb


EXPOSE 3838

RUN sudo apt-get -qq update
RUN sudo apt install r-cran-lme4 -y --allow-unauthenticated

COPY ./packageInstaller.R ./packageInstaller.R
RUN apt-get install -y software-properties-common
RUN sudo add-apt-repository -y ppa:opencpu/imagemagick &&\
    sudo apt-get update -y && \
    sudo apt-get install -y libmagick++-dev libmagic-dev default-jdk &&\
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install r-cran-rjava -y &&\
    sudo R -e "Sys.setenv(JAVA_HOME = \"/usr/lib/jvm/default-java\")" && R CMD javareconf
RUN sudo apt-get install -y libcurl4-openssl-dev libssl-dev libv8-3.14-dev libglu1-mesa-dev mesa-common-dev

ENTRYPOINT  \
            sudo Rscript ./packageInstaller.R - y  &&\
            exec shiny-server 2>&1