# clean and prepare system for creating a new installer
{% set git_clone = pillar.get('git_clone', 'c:\\repos\\salt') %}
{% set git_rev = pillar.get('git_rev', '2014.7local') %}
{% set git_upstream = pillar.get('git_upstream', 'https://github.com/saltstack/salt.git') %}

# clean out any salt installations from site-packages
for /D %f in (C:\Python27\Lib\site-packages\salt*) do rmdir %f /s /q:
  cmd.run

git clean -f -d:
  cmd.run:
    - cwd: {{ git_clone }}

git checkout .:
  cmd.run:
    - cwd: {{ git_clone }}

git fetch --tags:
  cmd.run:
    - cwd: {{ git_clone }}

git fetch --all:
  cmd.run:
    - cwd: {{ git_clone }}

#git pull:
  #cmd.run:
    #- cwd: {{ git_clone }}

reset_git_clone:
  git.latest:
    - force_reset: True
    - target: {{ git_clone }}
    - rev: {{ git_rev }}
    - name: {{ git_upstream }}
    #- always_fetch: True


{{ git_clone }}\build:
  file.absent

{{ git_clone }}\dist:
  file.absent
