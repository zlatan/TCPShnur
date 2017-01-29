FROM scratch
 
ARG REL_NAME
ARG REL_VSN=1
ARG ERTS_VSN
 
ENV BINDIR /erts-7.3.1.2/bin
ENV BOOT /releases/1/tcp_shnur
ENV CONFIG /releases/1/sys.config
ENV ARGS_FILE /releases/1/vm.args
 
ENV TZ=GMT

EXPOSE 8080
EXPOSE 9090
 
ENTRYPOINT exec ${BINDIR}/erlexec -boot_var /lib -boot ${BOOT} -noinput -config ${CONFIG} -args_file ${ARGS_FILE}
 
ADD _rel/tcp_shnur/ /
