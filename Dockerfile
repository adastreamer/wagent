FROM gcc:13.1 AS base

WORKDIR /wagent
COPY . /wagent

FROM base AS build-dynamic
RUN make rebuild

FROM base AS build-static
ENV CFLAGS_EXTRA="-static -pthread"
RUN make rebuild

FROM scratch AS dynamic
COPY --from=build-dynamic /wagent/bin/wagent_server /bin/wagent_server
COPY --from=build-dynamic /wagent/bin/wagent_client /bin/wagent_client

FROM scratch AS static
COPY --from=build-static /wagent/bin/wagent_server /bin/wagent_server
COPY --from=build-static /wagent/bin/wagent_client /bin/wagent_client
