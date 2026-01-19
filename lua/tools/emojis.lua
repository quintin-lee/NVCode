local emojis = {
  {
    key = "art",
    value = "🎨",
    description = "Improve structure / format of the code.",
  },
  {
    key = "zap",
    value = "⚡️",
    description = "Improve performance.",
  },
  {
    key = "fire",
    value = "🔥",
    description = "Remove code or files.",
  },
  {
    key = "fix",
    value = "🐞",
    description = "Fix a bug.",
  },
  {
    key = "patch",
    value = "🚑️",
    description = "Critical hotfix.",
  },
  {
    key = "feat",
    value = "✨",
    description = "Introduce new features.",
  },
  {
    key = "docs",
    value = "📝",
    description = "Add or update documentation.",
  },
  {
    key = "publish",
    value = "🚀",
    description = "Deploy stuff.",
  },
  {
    key = "lipstick",
    value = "💄",
    description = "Add or update the UI and style files.",
  },
  {
    key = "init",
    value = "🎉",
    description = "Begin a project.",
  },
  {
    key = "white_check_mark",
    value = "✅",
    description = "Add, update, or pass tests.",
  },
  {
    key = "lock",
    value = "🔒️",
    description = "Fix security issues.",
  },
  {
    key = "bookmark",
    value = "🔖",
    description = "Release / Version tags.",
  },
  {
    key = "rotating_light",
    value = "🚨",
    description = "Fix compiler / linter warnings.",
  },
  {
    key = "construction",
    value = "🚧",
    description = "Work in progress.",
  },
  {
    key = "green_heart",
    value = "💚",
    description = "Fix CI Build.",
  },
  {
    key = "arrow_down",
    value = "⬇️",
    description = "Downgrade dependencies.",
  },
  {
    key = "arrow_up",
    value = "⬆️",
    description = "Upgrade dependencies.",
  },
  {
    key = "tag",
    value = "📌",
    description = "Pin dependencies to specific versions.",
  },
  {
    key = "construction_worker",
    value = "👷",
    description = "Add or update CI build system.",
  },
  {
    key = "chart_with_upwar_ds_trend",
    value = "📈",
    description = "Add or update analytics or track code.",
  },
  {
    key = "recycle",
    value = "♻️",
    description = "Refactor code.",
  },
  {
    key = "heavy_plus_sign",
    value = "➕",
    description = "Add a dependency.",
  },
  {
    key = "heavy_minus_sign",
    value = "➖",
    description = "Remove a dependency.",
  },
  {
    key = "config",
    value = "🔧",
    description = "Add or update configuration files.",
  },
  {
    key = "hammer",
    value = "🔨",
    description = "Add or update development scripts.",
  },
  {
    key = "globe_with_meridi_ans",
    value = "🌐",
    description = "Internationalization and localization.",
  },
  {
    key = "pencil2",
    value = "✏️",
    description = "Fix typos.",
  },
  {
    key = "poop",
    value = "💩",
    description = "Write bad code that needs to be improved.",
  },
  {
    key = "rewind",
    value = "⏪️",
    description = "Revert changes.",
  },
  {
    key = "twisted_rightwards_arrows",
    value = "🔀",
    description = "Merge branches.",
  },
  {
    key = "file",
    value = "📦️",
    description = "Add or update compiled files or packages.",
  },
  {
    key = "alien",
    value = "👽️",
    description = "Update code due to external API changes.",
  },
  {
    key = "truck",
    value = "🚚",
    description = "Move or rename resources (e.g. = files, paths, routes).",
  },
  {
    key = "page_facing_up",
    value = "📄",
    description = "Add or update license.",
  },
  {
    key = "boom",
    value = "💥",
    description = "Introduce breaking changes.",
  },
  {
    key = "bento",
    value = "🍱",
    description = "Add or update assets.",
  },
  {
    key = "wheelchair",
    value = "♿️",
    description = "Improve accessibility.",
  },
  {
    key = "bulb",
    value = "💡",
    description = "Add or update comments in source code.",
  },
  {
    key = "beers",
    value = "🍻",
    description = "Write code drunkenly.",
  },
  {
    key = "speech_balloon",
    value = "💬",
    description = "Add or update text and literals.",
  },
  {
    key = "card_file_box",
    value = "🗃️",
    description = "Perform database related changes.",
  },
  {
    key = "loud_sound",
    value = "🔊",
    description = "Add or update logs.",
  },
  {
    key = "mute",
    value = "🔇",
    description = "Remove logs.",
  },
  {
    key = "busts_in_silhouette",
    value = "👥",
    description = "Add or update contributor(s).",
  },
  {
    key = "children_crossing",
    value = "🚸",
    description = "Improve user experience / usability.",
  },
  {
    key = "building_construction",
    value = "🏗️",
    description = "Make architectural changes.",
  },
  {
    key = "iphone",
    value = "📱",
    description = "Work on responsive design.",
  },
  {
    key = "clown_face",
    value = "🤡",
    description = "Mock things.",
  },
  {
    key = "egg",
    value = "🥚",
    description = "Add or update an easter egg.",
  },
  {
    key = "git",
    value = "🙈",
    description = "Add or update a .gitignore file.",
  },
  {
    key = "camera_flash",
    value = "📸",
    description = "Add or update snapshots.",
  },
  {
    key = "alembic",
    value = "⚗️",
    description = "Perform experiments.",
  },
  {
    key = "mag",
    value = "🔍️",
    description = "Improve SEO.",
  },
  {
    key = "label",
    value = "🏷️",
    description = "Add or update types.",
  },
  {
    key = "seedling",
    value = "🌱",
    description = "Add or update seed files.",
  },
  {
    key = "triangular_flag_on_post",
    value = "🚩",
    description = "Add, update, or remove feature flags.",
  },
  {
    key = "goal_net",
    value = "🥅",
    description = "Catch errors.",
  },
  {
    key = "dizzy",
    value = "💫",
    description = "Add or update animations and transitions.",
  },
  {
    key = "wastebasket",
    value = "🗑️",
    description = "Deprecate code that needs to be cleaned up.",
  },
  {
    key = "passport_control",
    value = "🛂",
    description = "Work on code related to authorization, roles and permissions.",
  },
  {
    key = "adhesive_bandage",
    value = "🩹",
    description = "Simple fix for a non-critical issue.",
  },
  {
    key = "monocle_face",
    value = "🧐",
    description = "Data exploration/inspection.",
  },
  {
    key = "coffin",
    value = "⚰️",
    description = "Remove dead code.",
  },
  {
    key = "test",
    value = "🧪",
    description = "Add a failing test.",
  },
  {
    key = "necktie",
    value = "👔",
    description = "Add or update business logic",
  },
  {
    key = "stethoscope",
    value = "🩺",
    description = "Add or update healthcheck.",
  },
}

return emojis
