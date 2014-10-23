{% set git_clone = pillar.get('git_clone', 'c:\\repos\\salt') %}
{% set git_rev = pillar.get('git_rev', '2014.7local') %}
{% if grains.get('cpuarch') == 'AMD64' %}
{% set program_files = 'Program Files (x86)' %}
{% else %}
{% set program_files = 'Program Files' %}
{% endif %}


include:
  - .cache_create
  - .reset

install_salt:
  cmd.run:
    - cwd: {{ git_clone }}
    - name: python setup.py install --force

make_sdist:
  cmd.run:
    - cwd: {{ git_clone }}
    - name: python setup.py sdist
    - require:
      - cmd: install_salt

make_bdist:
  cmd.run:
    - cwd: {{ git_clone }}
    - name: python setup.py bdist
    - require:
      - cmd: make_sdist

make_bdist_esky:
  cmd.run:
    - cwd: {{ git_clone }}
    - name: python setup.py bdist_esky
    - require:
      - cmd: make_bdist

extract_zip:
  module.run:
    - name: archive.unzip
    - dest: '{{ git_clone }}\pkg\windows\buildenv\'
    - zipfile: '{{ git_clone }}\dist\salt-*.win*.zip'
    - require:
      - cmd: make_bdist_esky


nsi_file:
  file.managed:
    - source: salt://windowsinstaller/Salt-Minion-Setup.nsi
    - name:  '{{ git_clone }}\pkg\windows\installer\Salt-Minion-Setup.nsi'
    - template: jinja
    - context:
      salt_version: {{ git_rev }}
    - require:
      - module: extract_zip


compile_nsi:
  cmd.run:
    - name: '"c:\{{ program_files }}\NSIS\makensis.exe" Salt-Minion-Setup.nsi'
    - cwd:  '{{ git_clone }}\pkg\windows\installer\'
    - require:
      - file: nsi_file

copy_exe_to_master:
  module.run:
    - name: cp.push_dir
    - path:  '{{ git_clone }}\pkg\windows\installer\'
    - glob: '*.exe'
    - require:
      - cmd: compile_nsi
