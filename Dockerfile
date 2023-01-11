FROM ubuntu:22.04

ENV FC_LANG en-US LC_CTYPE en_US.UTF-8

# dependencies
# RUN apt-get update -yq && apt-get install -yq bash fonts-dejavu-core fonts-dejavu-extra fontconfig curl openjdk-11-jre-headless && \
#     apt-get clean && \
#     rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
#     mkdir -p /app/certs && \
#     curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/certs/rds-combined-ca-bundle.pem  && \
#     keytool -noprompt -import -trustcacerts -alias aws-rds -file /app/certs/rds-combined-ca-bundle.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit && \
#     mkdir -p /plugins && chmod a+rwx /plugins && \
#     useradd --shell /bin/bash metabase

RUN apt-get update -yq && apt-get install -yq bash fonts-dejavu-core fonts-dejavu-extra fontconfig curl openjdk-11-jre-headless
RUN apt-get clean
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN mkdir -p /app/certs
RUN curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/certs/rds-combined-ca-bundle.pem
RUN keytool -noprompt -import -trustcacerts -alias aws-rds -file /app/certs/rds-combined-ca-bundle.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit
RUN mkdir -p /plugins && chmod a+rwx /plugins
RUN useradd --shell /bin/bash metabase

WORKDIR /app

# copy app from the offical image
COPY --from=metabase/metabase:v0.45.1 /app /app

RUN chown -R metabase /app

USER metabase
# expose our default runtime port
EXPOSE 3000

# run it
ENTRYPOINT ["/app/run_metabase.sh"]
