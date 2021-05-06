FROM archlinux

ENV HOME /app
WORKDIR /app
COPY . .
CMD ./init.sh
