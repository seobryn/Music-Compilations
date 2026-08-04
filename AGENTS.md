# Seobryn Music — AGENTS.md

> Nombre artístico del autor como productor musical: **Seobryn Music**.
> Contexto persistente del proyecto. opencode carga este archivo al iniciar sesión.
> Última revisión por el autor: 2026-08-04.

---

## 1. Propósito del proyecto

Repositorio personal de **Seobryn Music** donde el autor **genera, almacena y organiza canciones instrumentales propias**. Las canciones se crean con un DAW o con IA (actualmente Suno AI). Todo es instrumental — sin voces, sin letras.

**Géneros de trabajo:** Rock progresivo, Metal sinfónico, Power Metal y géneros afines.

**Audiencia:** uso personal del autor (biblioteca propia). No orientado a publicación por ahora.

---

## 2. Identidad musical (NO NEGOCIABLE)

Toda canción, prompt, sugerencia o trabajo en este proyecto debe respetar esta esencia. Si una propuesta la rompe, se corrige antes de avanzar.

- **Bajos profundos y prominentes** — el bajo es pilar de la mezcla, no relleno.
- **Batería con solos / breaks interesantes** — la percusión tiene personalidad propia, no es solo ritmo base.
- **Violines cuando encaje** — no obligatorio en todas, pero presencia frecuente; aportan la capa emocional/cinematográfica.
- **Sentimentalidad como motor** — el autor transmite lo que siente a través del sonido. Cada prompt debe describir la emoción que la canción debe expresar (tristeza, rabia, esperanza, melancolía, euforia, etc.) y la instrumentación debe servir a esa emoción, no al revés.
- **Coherencia entre tracks del mismo álbum** — una colección se escucha como un viaje, no como canciones aisladas.

---

## 3. Bandas de referencia (inspiración, no imitación)

Usar como guía de **estilo y esencia musical**. Nunca copiar melodía, letra o arreglos protegidos por derechos.

| Banda | Esencia que aporta |
|---|---|
| **Tool** | Compases complejos, atmósfera oscura, tensión ambiental |
| **Mago de Oz** | Fusión folk-metal, narrativa épica, instrumentación rica |
| **Epica** | Capas sinfónicas, dinámicas dramáticas, contraste piano/orquesta |
| **Slipknot** | Percusión intensa, agresividad contenida, disonancia controlada |
| **Nightwish** | Alcance cinematográfico, orquestación, melodías elevadas |

Cada álbum del proyecto está inspirado en la esencia musical de **una** de estas bandas (excepto `Sin Album`, ver §4).

---

## 4. Estructura de carpetas

```
Music-Compilations/
├── AGENTS.md                      ← este archivo
├── Logo.png                       ← logo del autor
├── Banner.png                     ← banner principal
├── scripts/
│   └── clean-mp3.sh               ← limpieza + taggeo de MP3 (ffmpeg)
└── <Género>/                      ← una carpeta por género (ej. Symphonic Metal)
    ├── <Album>/                   ← álbum inspirado en una banda
    │   ├── <track>.mp3
    │   ├── <track>.mp3
    │   └── <portada>.{png|jpg}    ← una sola pieza de arte por álbum
    └── Sin Album/                 ← canciones sueltas, sin álbum
        └── <track>.mp3
```

**Reglas:**
- `Sin Album` es la papeleta de canciones independientes que expresan una emoción puntual. Existe dentro del género al que más se acerquen estilísticamente. Es **plano**: sin subcarpetas, sin numeración.
- Cada álbum guarda **una sola portada** (mismo nombre o nombre descriptivo) junto a sus tracks.
- Los archivos pesados (`.mp3`, portadas) **sí van al repo** — el `.gitignore` actual no los excluye.
- El formato de exportación de audio es **MP3** (lo gestiona generalmente Suno AI). Si en el futuro se usa otro formato, añadirlo aquí.
- `.DS_Store` y metadatos del sistema **no** van al repo (ya están en `.gitignore`).

---

## 5. Suno AI — Reglas para prompts

Suno se usa para generar canción completa o base a partir de un prompt.

**Cuando el autor pida un prompt para una canción:**

1. **Idioma del prompt:** **SIEMPRE inglés.** Incluso si el título o la emoción descrita están en español.
2. **Optimizar para el parser de Suno** — Suno responde mejor a:
   - Tags de género/estilo al inicio (`Progressive metal`, `Symphonic power metal`, etc.)
   - Lista clara de instrumentación (`deep bass`, `orchestral strings`, `cinematic drums`, `violin lead`, `guitar solo`).
   - Indicadores de tempo/energía (`mid-tempo`, `driving`, `building`, `explosive climax`, `melodic`, `aggressive`, `atmospheric`).
   - Descriptor emocional explícito (`melancholic`, `epic`, `angry`, `hope`, `grief`, etc.).
   - Marcar `instrumental, no vocals` salvo que el autor indique lo contrario (en este proyecto, **siempre instrumental**).
3. **Incluir la esencia de la casa** en cada prompt: deep bass, drums with interesting patterns/solos, violins cuando aplique.
4. **Mencionar la banda/álbum de inspiración** si aplica, para anclar el estilo (ej. `in the style of Epica's symphonic layering`).
5. **Estructura sugerida del prompt:**
   ```
   [Genre tags]. [Tempo/energy]. [Instrumentation with deep bass and expressive drums].
   [Emotional core / feeling to convey]. [Reference style if applicable].
   Instrumental, no vocals. [Optional: structure cues — "building from soft intro to explosive climax"].
   ```

**Ejemplo canónico** (referencia, ajustar al caso):
```
Symphonic power metal, mid-tempo. Deep prominent bass, expressive drums with a
breakdown solo, layered violins and orchestral strings. Conveys grief turning into
hopeful defiance — melancholic verses building to an epic, uplifting climax.
Instrumental, no vocals. In the spirit of Nightwish's cinematic orchestration.
```

---

## 6. Convenciones de nombrado

- **Títulos de tracks:** siempre en **inglés**.
- **Prefijo numérico obligatorio** en todos los álbumes (`1.`, `2.`, `3.`, … con punto y espacio).
  - Único álbum existente sin numeración: `Universal Synergy` (ya publicado, se conserva tal cual).
- **`Sin Album` no lleva numeración** ni subcarpetas: canciones sueltas, planas.
- **Una sola portada por álbum** (mismo nombre o nombre descriptivo), junto a los tracks.

---

## 7. Idioma de trabajo

| Elemento | Idioma |
|---|---|
| Conversación con el autor | Español |
| Títulos de tracks | **Inglés, siempre** |
| Prompts para Suno | **Inglés, siempre** |
| Descripciones / notas en `AGENTS.md` | Español |

---

## 8. Lo que NO se hace

- ❌ Canciones con voces o letras (este proyecto es 100% instrumental).
- ❌ Copiar melodías, letras o arreglos de las bandas de referencia.
- ❌ Generar prompts en español para Suno.
- ❌ Sacrificar el bajo profundo o los breaks de batería por «limpiar» la mezcla.
- ❌ Emociones genéricas en los prompts — la emoción debe ser específica y sentida.

---

## 9. Estado actual del repositorio

| Álbum | Estado | Inspiración | Tracks |
|---|---|---|---|
| **Universal Synergy** | ✅ Completo y publicado | (por confirmar banda) | 4 numerados |
| **Whispers Before the Storm** | 🟡 En progreso (2 publicados + 1 en desarrollo) | **Mago de Oz** | 2 numerados (`1. From the Hollow to the Flame`, `2. The Quiet That Breaks`); track 3 en desarrollo |
| **Sin Album** | 📝 Papeleta | — | 1 (`Dissonance Engine.mp3`) |

Todos los títulos existentes están en **inglés**.

---

## 10. Tracks en desarrollo

### 3. What the Heart Whispered — *Whispers Before the Storm*
- **Emociones:** enamorado (intimidad, calidez, esperanza, anhelo).
- **Notas creativas:** silencios deliberados, rubato, cambios de tempo; progresivo con tintes folk-metal.
- **Archivo temporal esperado:** `cancion_3.mp3` (renombrar a `3. What the Heart Whispered.mp3` al agregarlo).
- **Prompt Suno (optimizado, en inglés):**
  ```
  Progressive rock with folk-metal influences, mid-tempo with rubato and
  dynamic tempo shifts. Deep prominent bass anchoring the low end, expressive
  drums with a breakdown solo and varied fills, layered violins weaving the
  melodic lead through Celtic-flavored acoustic passages and electric
  counterplay. Conveys the tender warmth of being in love — intimate, hopeful,
  longing — built with deliberate silences and dramatic rests that let emotion
  breathe. Tempo flows with the feeling: slow and intimate in the verses,
  swelling forward in the choruses, suspended in the pauses between.
  Instrumental, no vocals. In the spirit of Mago de Oz's folk-metal
  storytelling and progressive rock's dynamic contrast.
  ```

---

## 11. Workflow de nuevos tracks

Cuando el autor traiga un nuevo MP3 (de Suno o DAW) al álbum, el proceso automatizado es:

1. **Recibir el archivo** — el autor suele guardarlo en la carpeta del álbum con nombre temporal (ej. `cancion_3.mp3`).
2. **Limpiar y taggear** — ejecutar `scripts/clean-mp3.sh`:
   ```bash
   ./scripts/clean-mp3.sh \
     "<carpeta>/cancion_X.mp3" \
     "<carpeta>/N. <Título>.mp3" \
     "<Título en inglés>" \
     "<Nombre del álbum>" \
     "<N>" \
     "2026" \
     "<Género>"
   ```
   El script:
   - Borra TODA la metadata existente (ID3v1/v2, comments, lyrics, frames lyric).
   - Escribe tags propios: `artist=Seobryn Music`, `title`, `album`, `track`, `date=2026`, `genre`, `encoded_by=Seobryn Music`, `comment="Instrumental, no vocals"`.
   - Elimina el frame `TSSE` (que ffmpeg añade automáticamente con su número de versión).
   - Audita al final que ningún tag contenga rastros de AI/Suno/encoders (sale con código 2 si detecta algo).
   - Usa `-c:a copy` — cero pérdida de calidad, no re-encodifica.
3. **Actualizar `AGENTS.md`** — mover el track de "en desarrollo" a "publicado" en §9, fijar el género final en §10.
4. **Commit** — un commit por canción agregada con mensaje `feat: add <N>. <Título>`.

**Cuándo usar el script:**
- SIEMPRE que el autor pase un nuevo MP3 al repo (venga de Suno, Udio, o DAW propio).
- SIEMPRE antes de subir un track a SoundCloud u otra plataforma, para dejar la firma de Seobryn Music en los tags.

**Requisitos del sistema:**
- `ffmpeg` instalado (`brew install ffmpeg`).
- `eyeD3` instalado (`pip3 install --user eyeD3`). El script busca automáticamente en `~/Library/Python/3.9/bin/`, `~/Library/Python/3.13/bin/` y `~/.local/bin/`.

**Género por defecto si no se pasa:** `Instrumental Progressive Metal` (ajustar por álbum).

**Garantía anti-AI/Suno** (lo que NO aparece en los tags finales):
- ❌ "Suno", "AI", "artificial", "generated"
- ❌ "Lavf", "ffmpeg", "libav", "TSSE", "encoder"
- ❌ Cualquier rastro del proceso o de la herramienta generadora.

---

## 12. Tareas pendientes de definir con el autor

- [ ] **Whispers Before the Storm** — track 4: definir emoción y dirección creativa (cierre del álbum, "la tormenta").
- [ ] **Whispers Before the Storm** — track 3: pendiente de recibir el MP3 para renombrar `cancion_3.mp3` → `3. What the Heart Whispered.mp3` y ejecutarle `clean-mp3.sh`.
- [ ] **Universal Synergy**: confirmar la banda de inspiración (no declarada aún).
