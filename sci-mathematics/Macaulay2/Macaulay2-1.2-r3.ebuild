# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools elisp-common eutils flag-o-matic

IUSE="emacs"

DESCRIPTION="research tool for commutative algebra and algebraic geometry"
SRC_URI=" http://www.math.uiuc.edu/Macaulay2/Downloads/SourceCode/${P}-r8438-src.tar.bz2
	ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/factory-3-1-0.tar.gz \
	ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/libfac-3-1-0.tar.gz \
	http://www.math.uiuc.edu/Macaulay2/Extra/frobby_vmike3.tar.gz"
#	mirror://gentoo/${P}-src.tar.bz2

# We should keep frobby, factory and libfac in sync!

HOMEPAGE="http://www.math.uiuc.edu/Macaulay2/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

# The ntl version is a due to factory
# If <boehm-gc-7.0 is installed M2 download and install it internally
# sys-process/time is needed to run the checks
DEPEND="sys-libs/gdbm
	dev-libs/gmp
	>=dev-libs/ntl-5.4.1[gmp]
	>=dev-libs/boehm-gc-7.0
	>=sci-mathematics/pari-2.3.4[gmp]
	virtual/blas
	virtual/lapack
	dev-util/ctags
	sys-libs/ncurses
	sys-process/time
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE=70Macaulay2-gentoo.el

S="${WORKDIR}/${P}-r8438"

src_unpack() {
	unpack "${P}-r8438-src.tar.bz2"
	mkdir "${S}/BUILD/tarfiles"
	# Put sourcfile in the right location:
	cp "${DISTDIR}/frobby_vmike3.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/factory-3-1-0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
	cp "${DISTDIR}/libfac-3-1-0.tar.gz" "${S}/BUILD/tarfiles/" \
		|| die "copy failed"
}

src_prepare () {
	# Fixes an issue with Doc. Probably gone in 1.3
	cd "${S}/Macaulay2/packages/Macaulay2Doc"
	sed "/^ *SourceCode => applicationDirectory.*$/d" -i doc13.m2

	# This might help if ntl is built with gf2x support
	# Currently we run into --as-needed problems then.
	cd "${S}"
	sed 's/"-lntl"/"-lntl" "-lgf2x -lntl"/' -i "${S}/configure.ac"

	eautoreconf
}

src_configure (){

	# Recommended in bug #268064 Possibly unecessary since
	# its a local problem of original reporter.

	if ! use emacs; then
		tags="ctags"
	fi

	# --as-needed should be possible:
	append-ldflags "-L${WORKDIR}/$(get_libdir) -Wl,--no-as-needed"
	CPPFLAGS="-I/usr/include/gc -I${WORKDIR}/include" \
		./configure --prefix="${D}/usr" --disable-encap \
		|| die "failed to configure Macaulay"
}

src_compile() {
	# Parallel build ?
	emake -j1 || die "failed to build Macaulay"
}

src_test() {
	make check || die "tests failed"
}

src_install () {

	make install || die "install failed"

	# nothing useful in here, get rid of it
	# NOTE: Macaulay installs into lib even on amd64 hence don't
	# replace lib with $(get_libdir) below!
	rm -fr "${D}"/usr/lib \
		|| die "failed to remove empty /usr/lib"

	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "If you want to set a hot key for Macaulay2 in Emacs add a line similar to"
		elog "(global-set-key [ f12 ] 'M2)"
		elog "in order to set it to F12 (or choose a different one)."
	fi
}
pkg_postrm() {
	use emacs && elisp-site-regen
}
