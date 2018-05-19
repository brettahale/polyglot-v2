FROM arm32v7/node:9.4 as builder

COPY qemu-arm-static /usr/bin/qemu-arm-static

USER node
COPY --chown=node . /home/node/polyglotv2/
WORKDIR /home/node/polyglotv2
RUN npm -q --production install

FROM arm32v7/node:9.4

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apt-get -y update && apt-get -y install python-pip python2.7

WORKDIR /home/node/polyglotv2
RUN chown -R node:node /home/node
RUN chmod -R 0755 /home/node
COPY --from=builder --chown=node /home/node/polyglotv2/lib ./lib
#COPY --from=builder --chown=node /home/node/polyglotv2/nsindex ./nsindex
COPY --from=builder --chown=node /home/node/polyglotv2/bin ./bin
COPY --from=builder --chown=node /home/node/polyglotv2/package.json ./
COPY --from=builder --chown=node /home/node/polyglotv2/node_modules ./node_modules

USER node

RUN mkdir -p /home/node/.polyglot/nodeservers
RUN chown -R node:node /home/node/.polyglot/nodeservers
RUN chmod -R 0755 /home/node/.polyglot/nodeservers
EXPOSE 3000

CMD ["npm","start"]
#
#FROM arm32v7/python:3.6-slim
#
#EXPOSE 3000
#
#RUN mkdir -p /opt/udi-polyglotv2/
#WORKDIR /opt/udi-polyglotv2/
#COPY polyglot-v2-linux-armv7 ./
#
#CMD ["./polyglot-v2-linux-armv7"]
