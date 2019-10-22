FROM solr:5.5

COPY solrconfig.xml /opt/solr/server/solr/configsets/basic_configs/conf/

# Create configsets for CKAN versions
RUN \
  for ckan_version in ckan2_3 ckan2_5; do \
    mkdir -p /opt/solr/server/solr/configsets/$ckan_version ; \
    cp -r /opt/solr/server/solr/configsets/basic_configs/conf/ /opt/solr/server/solr/configsets/$ckan_version/ ; \
  done

# Copy schema
COPY schema2_3.xml /opt/solr/server/solr/configsets/ckan2_3/conf/schema.xml
COPY schema2_5.xml /opt/solr/server/solr/configsets/ckan2_5/conf/schema.xml
