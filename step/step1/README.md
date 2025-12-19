## FZF Step1. 사용법 알아보기

`cat sample.txt | fzf` 를 통해 fzf 를 실행해보자.

```sh
cat sample.txt | fzf
```

### 검색 패턴

기본적으론 fuzzy 검색을 지원해준다.

- `music` : `music` 을 패턴으로 포함하고 있는 요소 선택

```
notes/must-i-cook.md
live.music
videos/music_story.mp4
docs/music-theory.pdf
music-scores/Beethoven/symphony-no-5.pdf
music/pop/wilder days.mp3
music/pop/wild world.flac
music/classic/wild.mp3
music/rock/anthem.mp3
music/rock/fire.mp3
music.mp3.backup
MUSIC_room
musiclive
musicbox
music
```

조금 더 정확하게, 특별하게 검색을 하고 싶다면 아래 패턴을 활용해보자.

- `'music` : `music` 을 정확히 포함하고 있는 요소 선택

```
live.music
videos/music_story.mp4
docs/music-theory.pdf
music-scores/Beethoven/symphony-no-5.pdf
music/pop/wilder days.mp3
music/pop/wild world.flac
music/classic/wild.mp3
music/rock/anthem.mp3
music/rock/fire.mp3
music.mp3.backup
MUSIC_room
musiclive
musicbox
music
```

- `.mp3$` : `.mp3` 로 끝나는 요소 선택

```
music/pop/wilder days.mp3
music/classic/wild.mp3
music/rock/anthem.mp3
music/rock/fire.mp3
```

- `!music` : `music` 을 포함하지 않는 요소 선택

```
todo.txt
dev/src/UtilClass.java
config/server-log-backup.zip
project/data/data_analysis_report_v2.docx
notes/must-i-cook.md
```

- `music mp4` : music 을 포함하고, mp4를 포함하는 요소 선택

```
videos/music_story.mp4
```

