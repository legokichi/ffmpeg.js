libvpx/libvpx.so:
	cd libvpx && \
	emconfigure ./configure \
		--prefix="$(pwd)/dist" \
		--disable-dependency-tracking \
		--disable-runtime-cpu-detect \
		--disable-examples \
		--disable-docs \
		--disable-webm-io \
		--disable-libyuv \
		--disable-unit_tests \
		--disable-install_bins \
		--disable-install_libs \
		--disable-encode_perf_tests \
		--disable-decode_perf_tests \
		--target=generic-gnu \
		--extra-cflags="-O2" \
		&& \
	emmake make -j8 && \
	emmake make install
# --target=asmjs-unknown-emscripten \
# --disable-multithread
# --extra-cflags="-g -O0"
# --disable-optimizations
#--enable-shared \
#--disable-static \

opus/libopus.so:
	cd opus && \
	./autogen.sh && \
	CFLAGS=-v CPPFLAGS=-v LDFLAGS=-v CCLDFLAGS=-v CCASFLAGS=-v \
	emconfigure ./configure \
		CFLAGS=-O2 \
		--prefix="$(pwd)/dist" \
		--disable-doc \
		--disable-extra-programs \
		--disable-asm \
		--disable-rtcd \
		--disable-intrinsics \
		&& \
	emmake make -j8 && \
	emmake make install
#--disable-static 

FFmpeg/ffmpeg.bc:
	cd FFmpeg && \
	emconfigure ./configure \
		--prefix=$(pwd)/dist \
		\
		--enable-gpl \
		--enable-version3 \
		--enable-nonfree \
		\
		--enable-static \
		--disable-shared \
		--disable-small \
		--disable-runtime-cpudetect \
		--disable-gray \
		--disable-swscale-alpha \
		\
		--disable-ffplay \
		--disable-ffprobe \
		--disable-ffserver \
		\
		--disable-doc \
		\
		--disable-avdevice \
		--enable-avcodec \
		--enable-avformat \
		--enable-swresample \
		--disable-swscale \
		--disable-postproc \
		--enable-avfilter \
		--disable-avresample \
		--disable-pthreads \
		--disable-w32threads \
		--disable-os2threads \
		--disable-network \
		\
		--disable-encoders \
		--disable-decoders \
		--disable-hwaccels \
		--disable-muxers \
		--enable-muxer=webm \
		--disable-demuxers \
		--enable-demuxer=matroska \
		--disable-parsers \
		--disable-bsfs \
		--disable-protocols \
		--enable-protocol=file \
		--disable-devices \
		--disable-filters \
		\
		--disable-bzlib \
		--disable-iconv \
		--disable-lzma \
		--disable-schannel \
		--disable-sdl2 \
		--disable-securetransport \
		--disable-xlib \
		--disable-zlib \
		\
		--disable-audiotoolbox \
		--disable-cuda \
		--disable-cuvid \
		--disable-d3d11va \
		--disable-dxva2 \
		--disable-nvenc \
		--disable-vaapi \
		--disable-vda \
		--disable-vdpau \
		--disable-videotoolbox \
		\
		--enable-cross-compile \
		--arch=x86_32 \
		--cpu=generic \
		--target-os=none \
		--cc=emcc \
		\
		--disable-asm \
		--disable-altivec \
		--disable-inline-asm \
		--disable-yasm \
		--disable-fast-unaligned \
		\
		--disable-debug \
		--disable-optimizations \
		--disable-stripping \
		\
		&& \
	emmake make -j8 && \
	cp ffmpeg ffmpeg.bc
#
		--ar=emar \
		--as=emas \
		--cc=emcc \
		--ld=emcc \


		--enable-lto \
# sed -i '' 's/ARFLAGS=/ARFLAGS=-/' ffbuild/config.mak && \
# EM_PKG_CONFIG_PATH=../opus/dist/lib/pkgconfig \
# --pkg-config-flags="--static" \
#--extra-cflags="-I../libvpx -I../opus/dist/include" \
#--extra-ldflags="-L../libvpx -L../opus/dist/lib" \
#                 --enable-decoder=vp8 \
#                --enable-decoder=vp9 \
#                --enable-decoder=opus \
#                --enable-demuxer=matroska \
#                --enable-encoder=libvpx_vp8 \
#                --enable-encoder=libvpx_vp9 \
#                --enable-encoder=libopus \
#                --enable-filter=scale \
#                --enable-filter=crop \
#                --enable-filter=overlay \
#                --enable-filter=aresample \
#                --extra-cflags="-I../libvpx -I../opus/dist/include" \
#                --extra-ldflags="-L../libvpx -L../opus/dist/lib" \
#                --extra-libs="../libvpx/libvpx.a ../opus/dist/lib/libopus.a"



ffmpeg-webm.js: $(FFMPEG_WEBM_BC) $(PRE_JS) $(POST_JS_SYNC)
	emcc -O2 ffmpeg.o ./libavcodec/libavcodec.a ./libavdevice/libavdevice.a ./libavfilter/libavfilter.a libavformat/libavformat.a libavutil/libavutil.a ../opus/dist/lib/libopus.a ../libvpx/libvpx.a ./libswscale/libswscale.a ./libswresample/libswresample.a -o ffmpeg.js
	emcc $(FFMPEG_WEBM_BC) $(WEBM_SHARED_DEPS) \
		--post-js $(POST_JS_SYNC) \
		$(EMCC_COMMON_ARGS)