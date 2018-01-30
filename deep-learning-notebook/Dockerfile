FROM ckbd/base-notebook
USER root
ENV INSTALL_TF=true
COPY start-tf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-tf.sh
CMD ["start-tf.sh"]
USER root 
