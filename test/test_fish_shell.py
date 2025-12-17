# Copyright 2016-2018 Dirk Thomas
# Licensed under the Apache License, Version 2.0

import pytest
from pathlib import Path
from colcon_fish.shell.fish import FishShell
from colcon_core.plugin_system import SkipExtensionException
import sys


def test_fish_shell_init():
    # Test successful initialization
    fish_shell = FishShell()
    assert isinstance(fish_shell, FishShell)


def test_create_prefix_script(tmp_path):
    # Test creating prefix scripts
    fish_shell = FishShell()
    prefix_path = tmp_path / "test_prefix"
    prefix_path.mkdir()

    result = fish_shell.create_prefix_script(prefix_path, merge_install=False)

    # Check if the expected files were created
    assert len(result) == 3
    assert (prefix_path / "local_setup.fish").exists()
    assert (prefix_path / "_local_setup_util_fish.py").exists()
    assert (prefix_path / "setup.fish").exists()


def test_create_package_script(tmp_path):
    # test creating package script
    fish_shell = FishShell()
    prefix_path = tmp_path / "test_prefix"
    share_path = prefix_path / "share" / "test_package"
    share_path.mkdir(parents=True)

    # create mock hooks
    hooks = [
        (Path("hook1.fish"), "content1"),
        (Path("hook2.sh"), "content2"),  # this should be filtered out
        (Path("hook3.fish"), "content3")
    ]

    result = fish_shell.create_package_script(
        prefix_path, "test_package", hooks
    )

    # check if the package script was created
    assert len(result) == 1
    assert (prefix_path / "share" / "test_package" / "package.fish").exists()


@pytest.mark.skipif(sys.platform != "win32", reason="Windows-specific test")
def test_windows_skip():
    # Test that initialization raises SkipExtensionException on Windows
    with pytest.raises(SkipExtensionException):
        FishShell()
