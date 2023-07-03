FROM gcc:13.1
WORKDIR /wagent
COPY . /wagent
RUN make recompile