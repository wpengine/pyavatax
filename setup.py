#! /usr/bin/env python
from os import path
from setuptools import setup, find_packages

# python setup.py sdist
# python setup.py sdist bdist_wininst upload

PACKAGE_NAME = 'PyAvaTax'
MODULE_NAME  = PACKAGE_NAME.lower()
VERSION_FILE = "VERSION"

def semver():
    """
    Return the semver string in the format {major}.{minor}.{patch}.

    This reads the version from VERSION, which is saved in a file
    automatically by the build process.
    """
    this_dir = path.dirname(path.abspath(__file__))
    patch_file = path.join(this_dir, MODULE_NAME, VERSION_FILE)

    try:
        with open(patch_file) as f:
            return f.read().strip()
    except FileNotFoundError:
        # I'd really rather fail hard here, to reduce the chance of the package
        # getting deployed with an "unknown" version. However, we don't
        # necessarily have a BUILD_NUMBER when running tests, or using setup.py
        # from our Dockerfile, so this allows those to function:
        return "0.0.0"


setup(
    name=PACKAGE_NAME,
    url = 'http://github.com/wpengine/pyavatax/',
    author = 'John Obelenus',
    author_email = 'jobelenus@activefrequency.com',
    version=semver(),
    install_requires = ['requests>=2.5.3,<3', 'decorator>=3.4.0', 'six>=1.9.0'],
    tests_require=['Django>=1.7.1', 'pytest'],
    package_data = {
        '': ['*.txt', '*.rst', '*.md'],
        # Include the VERSION_FILE so we can use the
        # automatically-incremented version number in releases:
        MODULE_NAME: [VERSION_FILE]
    },
    packages=find_packages(),
    license='BSD',
    long_description="PyAvaTax is a Python library for easily integrating Avalara's RESTful AvaTax API Service",
)
