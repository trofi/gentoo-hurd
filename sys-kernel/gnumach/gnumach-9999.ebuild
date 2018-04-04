# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="GNU microkernel, a base for GNU Hurd"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/gnumach.html"
#SRC_URI="ftp://ftp.gnu.org/gnu/gnumach/gnumach-${PV}.tar.gz"
EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/gnumach.git"
SLOT="0"
KEYWORDS=""
LICENSE="GPL-2+"
IUSE="headers-only"

CTARGET=${CATEGORY#cross-}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local confargs=(
		--prefix="${EPREFIX}"/usr/${CTARGET}/usr
	)
	use headers-only && confargs+=(
		# Assume we don't have working cross-compiler
		CC=$(tc-getBUILD_CC)
	)
	econf --host=${CTARGET} "${confargs[@]}"
}

src_compile() {
	use headers-only && return
}

src_test() {
	use headers-only && return
}

src_install() {
	if use headers-only; then
		emake DESTDIR="${D}" install-data
	else
		default
	fi

	if is_crosscompile ; then
		# On hurd gcc expects system headers to be in /include, not /usr/include
		dosym usr/include /usr/${CTARGET}/include
	fi
}
