# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Main function library of the Protein X-ray crystallography toolkit"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-3"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"


