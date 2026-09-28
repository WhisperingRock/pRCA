FROM ubuntu:24.04

#ARG VERILATOR_VERSION=983a06a16f2aea1cf4bda3a45099c8bad24d112c\
ARG VERILATOR_REF=stable
ARG UVM_URL=https://accellera.org/images/downloads/standards/uvm/Accellera-1800.2-2017-1.0.tar.gz

# ~~~~ Required Dependencies ~~~~
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	wget \
	ca-certificates \
	git \
	help2man \
	perl \
	python3 \
	make \
	autoconf \
	g++ \
	flex \
	bison \
	ccache \
	libgoogle-perftools-dev \
	libjemalloc-dev \
	numactl \
	perl-doc \
	&& rm -rf /var/lib/apt/lists/*

# ~~~~ Optional Dependencies ~~~~
RUN apt-get update && for package in \
        libfl2 \
        libfl-dev \
        zlibc \
        zlib1g \
        zlib1g-dev \
        liblz4-1 \
        liblz4-dev \
    ; do \
        if apt-get install -y --no-install-recommends "$package"; then \
            echo "Installed optional package: $package"; \
        else \
            echo "WARNING: Could not install optional package: $package" >&2; \
        fi; \
    done \
    && rm -rf /var/lib/apt/lists/*

# ~~~~ Verilator Build ~~~~
RUN git clone --depth 1 --branch ${VERILATOR_REF} \
      https://github.com/verilator/verilator.git /tmp/verilator \
    && cd /tmp/verilator \
    && autoconf \
    && ./configure --prefix=/usr/local \
    && make -j"$(nproc)" \
    && make install \
	&& verilator --version \
    && rm -rf /tmp/verilator


# ~~~~ Grab UVM Library ~~~~
RUN mkdir -p /opt/uvm \
    && wget -qO /tmp/uvm.tar.gz "${UVM_URL}" \
    && tar -xzf /tmp/uvm.tar.gz \
        --strip-components=1 \
        -C /opt/uvm \
    && rm -f /tmp/uvm.tar.gz

ENV UVM_HOME=/opt/uvm/src
ENV PATH="/usr/local/bin:${PATH}"
WORKDIR /workspace


# Validate the installation
RUN command -v verilator \
    && verilator --version \
    && test -f "${UVM_HOME}/uvm_pkg.sv"

CMD ["bash"]


