FROM solr:7.5

COPY schema.xml /opt/solr/server/solr/configsets/basic_configs/conf/
COPY schema.xml /opt/solr/example/solr/ckan/conf/schema.xml

#RUN solr start && \
#    solr create_core -c ckan -d basic_configs

VOLUME /var/lib/solr
