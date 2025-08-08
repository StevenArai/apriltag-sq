// SPDX-FileCopyrightText: Copyright (c) Ken Martin, Will Schroeder, Bill Lorensen
// SPDX-License-Identifier: BSD-3-Clause
const char apriltag_detect_quads_docstring[] =
"Detects quads in the input image and returns a list of them.\n"
"\n"
"This method is useful for debugging the quad detection process or for applications\n"
"that only require finding rectangular shapes in an image, without decoding them\n"
"as AprilTags.\n"
"\n"
"Args:\n"
"    image (numpy.ndarray): A grayscale image (2D numpy array with dtype=uint8).\n"
"\n"
"Returns:\n"
"    list: A list of numpy arrays. Each element in the list is a 4x2 numpy array\n"
"          representing the four corners of a detected quad in pixel coordinates.\n"
"          The corners are ordered counter-clockwise.\n"
"";
