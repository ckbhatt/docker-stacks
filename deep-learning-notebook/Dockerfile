FROM ckbd/base-notebook
USER root
COPY jupyter_notebook_config.py /etc/jupyter/
ENV INSTALL_TF=true

COPY azurecontents azurecontents
RUN pip install ./azurecontents

RUN apt-get update && apt-get install -yqq zip && \
	pip install scikit-image scikit-learn seaborn h5py

COPY start-tf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-tf.sh
CMD ["start-tf.sh"]
USER root 
