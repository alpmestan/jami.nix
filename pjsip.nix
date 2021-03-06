{ stdenv, fetchFromGitHub, openssl, libsamplerate, alsaLib }:

stdenv.mkDerivation rec {
  pname = "pjsip";
  version = "3e7b75cb2e482baee58c1991bd2fa4fb06774e0d";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pjproject";
    rev = version;
    sha256 = "1aklicpgwc88578k03i5d5cm5h8mfm7hmx8vfprchbmaa2p8f4z0";
  };

  patchdir = ./patches;

  patches = [
    "${patchdir}/0001-rfc6544.patch"
    "${patchdir}/0002-rfc2466.patch"
    "${patchdir}/0003-add-tcp-keep-alive.patch"
    "${patchdir}/0004-multiple_listeners.patch"
    "${patchdir}/0005-fix_ebusy_turn.patch"
    "${patchdir}/0006-ignore_ipv6_on_transport_check.patch"
    "${patchdir}/0007-pj_ice_sess.patch"
    "${patchdir}/0008-fix_ioqueue_ipv6_sendto.patch"
    "${patchdir}/0009-add-config-site.patch"
  ];

  buildInputs = [ openssl libsamplerate alsaLib ];

  preConfigure = ''
    export LD=$CC
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${pname}-${version}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${pname}-${version}/samples
  '';

  # We need the libgcc_s.so.1 loadable (for pthread_cancel to work)
  dontPatchELF = true;

  meta = {
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [olynch];
    platforms = with stdenv.lib.platforms; linux;
  };
}
