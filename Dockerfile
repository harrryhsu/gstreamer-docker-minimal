FROM alpine:3.19.1 as builder

WORKDIR /gstreamer

RUN apk update
RUN apk add build-base libxml2-dev bison flex glib-dev gobject-introspection-dev libcap-dev libcap-utils meson perl wget

ARG GST_BUILD_VERSION=1.24
RUN wget https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/${GST_BUILD_VERSION}/gstreamer-${GST_BUILD_VERSION}.tar.gz && \
	tar -xvzf gstreamer-${GST_BUILD_VERSION}.tar.gz 

WORKDIR /gstreamer/gstreamer-${GST_BUILD_VERSION}

RUN	meson --prefix=/gstbin  \
	-Dauto_features=disabled \
	-Dgstreamer:tools=enabled \
	-Dbase=enabled \
	-Dgood=enabled \
	-Dbad=enabled \
	-Dgst-plugins-base:typefind=enabled \
	-Dgst-plugins-base:playback=enabled \
	-Dgst-plugins-base:volume=enabled \
	-Dgst-plugins-base:audioconvert=enabled \
	-Dgst-plugins-base:app=enabled \
	-Dgst-plugins-good:isomp4=enabled \
	-Dgst-plugins-good:rtp=enabled \
	-Dgst-plugins-good:udp=enabled \
	-Dgst-plugins-good:rtsp=enabled \
	-Dgst-plugins-good:rtpmanager=enabled \
	-Dgst-plugins-good:audioparsers=enabled \
	-Dgst-plugins-bad:videoparsers=enabled \
	build

RUN meson compile -C build

RUN meson install -C build

FROM alpine:3.19.1 as final

WORKDIR /work

RUN apk add gobject-introspection

ENV PATH=/gstbin/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/lib:/gstbin/lib:/usr/local/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH=/gstbin/lib/pkgconfig

COPY --from=builder /gstbin /gstbin
