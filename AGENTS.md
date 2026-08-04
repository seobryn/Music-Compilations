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
└── Seobryn Music/                 ← root de todas las canciones (no organiza por género)
    ├── <Album>/                   ← cada álbum, un folder directo (sin género intermedio)
    │   ├── <track>.mp3
    │   ├── <track>.mp3
    │   └── <portada>.{png|jpg}    ← una sola pieza de arte por álbum
    └── Sin Album/                 ← canciones sueltas, sin álbum
        └── <track>.mp3
```

**Reglas:**
- La organización es **por álbum**, no por género. Cada álbum vive directamente bajo `Seobryn Music/`. El género se declara en los tags ID3 y en `AGENTS.md §9`, no en la jerarquía de carpetas.
- `Sin Album` es la papeleta de canciones independientes que expresan una emoción puntual. Es **plano**: sin subcarpetas, sin numeración.
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
| **Whispers Before the Storm** | ✅ Completo y publicado | **Mago de Oz** | 4 numerados (`1. From the Hollow to the Flame`, `2. The Quiet That Breaks`, `3. What the Heart Whispered`, `4. Against the Breaking Storm`) |
| **Sin Album** | 📝 Papeleta | — | 1 (`Dissonance Engine.mp3`) |

Todos los títulos existentes están en **inglés**.

---

## 10. Workflow de nuevos tracks

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
   El script ejecuta un pipeline de 5 pasos para garantizar cero rastros:
   1. **ffmpeg** — strip ALL ID3 metadata con `-map_metadata -1`, escribe tags propios (`artist=Seobryn Music`, `title`, `album`, `track`, `date`, `genre`, `encoded_by`, `comment="Instrumental, no vocals"`). `-c:a copy` preserva el bitstream.
   2. **eyeD3** — elimina el frame `TSSE` (encoder=Lavf<version>) que ffmpeg añade automáticamente.
   3. **Python (`strip-xing-encoder.py`)** — blanquea el campo "Lavf"/"LAME" en dos lugares del bitstream: la extensión LAME del header Xing al inicio, y el LAME Tag al final del archivo (para VBR seek). Reemplaza 9 bytes por 9 espacios.
   3.5. **`xattr -c`** — borra los extended attributes macOS. Finder guarda la URL de origen del archivo (p. ej. `https://suno.com/`) en `com.apple.metadata:kMDItemWhereFroms`, que aparece como **"Where From"** en "Show Info → More Info". Sin esto, Finder revela el origen aunque los tags ID3 estén limpios.
   4. **Auditoría integral** — sale con código 2 si queda cualquier rastro. Comprueba tres cosas: (a) tags ID3 (ffprobe), (b) bytes crudos del archivo (Python: `LAME`, `Lavf`, `libav`), (c) xattr `kMDItemWhereFroms`.
3. **Actualizar `AGENTS.md`** — añadir el track al estado en §9 (con su número y género final), quitar la línea de "pendiente de MP3" en §11 si aplica.
4. **Commit** — un commit por canción agregada con mensaje `feat: add <N>. <Título>`.

**Cuándo usar el script:**
- SIEMPRE que el autor pase un nuevo MP3 al repo (venga de Suno, Udio, o DAW propio).
- SIEMPRE antes de subir un track a SoundCloud u otra plataforma, para dejar la firma de Seobryn Music en los tags.

**Requisitos del sistema:**
- `ffmpeg` instalado (`brew install ffmpeg`).
- `eyeD3` instalado (`pip3 install --user eyeD3`). El script busca automáticamente en `~/Library/Python/3.9/bin/`, `~/Library/Python/3.13/bin/` y `~/.local/bin/`.
- `python3` (incluido en macOS y Linux por defecto).

**Género por defecto si no se pasa:** `Instrumental Progressive Metal` (ajustar por álbum).

**Garantía anti-AI/Suno** (lo que NO aparece en los tags finales):
- ❌ "Suno", "AI", "artificial", "generated"
- ❌ "Lavf", "ffmpeg", "libav", "TSSE", "encoder"
- ❌ "LAME", "LAME3.100" (cualquier firma del encoder, en tags ID3 o bytes crudos)
- ❌ URL "Where From" de macOS en `com.apple.metadata:kMDItemWhereFroms` (Finder "Show Info → More Info")
- ❌ Cualquier rastro del proceso o de la herramienta generadora.

---

## 11. Tareas pendientes de definir con el autor

- [ ] **Universal Synergy**: confirmar la banda de inspiración (no declarada aún).
