FROM gcc:11.4.0
COPY . /wagent
WORKDIR /wagent
RUN make recompile