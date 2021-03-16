return {
  version = "1.4",
  luaversion = "5.1",
  tiledversion = "1.4.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 20,
  tileheight = 20,
  nextlayerid = 7,
  nextobjectid = 310,
  properties = {},
  tilesets = {
    {
      name = "ruins1",
      firstgid = 1,
      filename = "../../Tilesets/ruins1.tsx",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "../../Tilesets/ruins1.png",
      imagewidth = 160,
      imageheight = 380,
      transparentcolor = "#c386ff",
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 20,
        height = 20
      },
      properties = {},
      terrains = {},
      tilecount = 152,
      tiles = {}
    },
    {
      name = "ruins2",
      firstgid = 153,
      filename = "../../Tilesets/ruins2.tsx",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "../../Tilesets/ruins2.png",
      imagewidth = 160,
      imageheight = 260,
      transparentcolor = "#c386ff",
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 20,
        height = 20
      },
      properties = {},
      terrains = {},
      tilecount = 104,
      tiles = {}
    },
    {
      name = "ruins3",
      firstgid = 257,
      filename = "../../Tilesets/ruins3.tsx",
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "../../Tilesets/ruins3.png",
      imagewidth = 160,
      imageheight = 180,
      transparentcolor = "#c386ff",
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 20,
        height = 20
      },
      properties = {},
      terrains = {},
      tilecount = 72,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 1,
      name = "Tile Layer 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        163, 163, 30, 23, 23, 24, 163, 163, 22, 23, 23, 23, 31, 163, 163, 163,
        163, 30, 24, 259, 259, 260, 163, 163, 258, 259, 259, 259, 22, 31, 163, 163,
        163, 16, 260, 259, 259, 260, 163, 163, 258, 259, 259, 259, 258, 22, 31, 163,
        163, 16, 260, 267, 267, 268, 163, 163, 266, 267, 267, 267, 258, 258, 14, 163,
        163, 16, 268, 17, 17, 17, 162, 162, 17, 17, 17, 17, 266, 258, 14, 163,
        163, 16, 222, 17, 17, 25, 162, 34, 17, 17, 188, 17, 17, 266, 14, 163,
        163, 16, 222, 17, 17, 162, 162, 17, 17, 17, 184, 17, 17, 222, 14, 163,
        163, 16, 222, 17, 17, 162, 162, 17, 17, 17, 184, 17, 17, 222, 14, 163,
        163, 16, 222, 17, 17, 33, 162, 26, 17, 17, 184, 17, 17, 222, 14, 163,
        163, 163, 222, 17, 17, 17, 33, 162, 26, 17, 191, 17, 17, 155, 163, 163,
        163, 163, 163, 163, 222, 17, 17, 162, 162, 17, 17, 17, 155, 163, 163, 163,
        163, 163, 163, 163, 163, 163, 163, 162, 162, 163, 163, 163, 163, 163, 163, 163
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 2,
      name = "Tile Layer 2",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 309, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 240, 0, 0, 0, 0, 0, 0, 0, 239, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 208, 232, 0, 0, 0, 0, 0, 0, 0, 0, 231, 207, 0, 0,
        0, 0, 0, 208, 208, 232, 0, 0, 0, 0, 0, 231, 207, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "collision",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 60,
          width = 80,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 260,
          y = 100,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 120,
          width = 20,
          height = 60,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 60,
          y = 60,
          width = 60,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 80,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 20,
          y = 100,
          width = 20,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 60,
          y = 200,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 220,
          width = 40,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 180,
          y = 220,
          width = 60,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 96,
          name = "",
          type = "",
          shape = "polygon",
          x = 60,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -20, y = -20 },
            { x = -20, y = 0 }
          },
          properties = {}
        },
        {
          id = 175,
          name = "",
          type = "",
          shape = "polygon",
          x = 80,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 20, y = 20 },
            { x = 0, y = 20 }
          },
          properties = {}
        },
        {
          id = 176,
          name = "",
          type = "",
          shape = "polygon",
          x = 240,
          y = 220,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 40, y = -40 },
            { x = 40, y = 0 }
          },
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "events",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 45,
          name = "button",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["good"] = false
          }
        },
        {
          id = 169,
          name = "button",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 120,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["good"] = false
          }
        },
        {
          id = 170,
          name = "button",
          type = "",
          shape = "rectangle",
          x = 220,
          y = 100,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["good"] = true
          }
        },
        {
          id = 171,
          name = "button",
          type = "",
          shape = "rectangle",
          x = 180,
          y = 100,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["good"] = true
          }
        },
        {
          id = 172,
          name = "button",
          type = "",
          shape = "rectangle",
          x = 180,
          y = 140,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["good"] = true
          }
        },
        {
          id = 173,
          name = "button",
          type = "",
          shape = "rectangle",
          x = 220,
          y = 140,
          width = 20,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {
            ["good"] = true
          }
        },
        {
          id = 307,
          name = "wallswitch",
          type = "",
          shape = "rectangle",
          x = 206,
          y = 53,
          width = 7,
          height = 15,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 308,
          name = "largedoor",
          type = "",
          shape = "rectangle",
          x = 123,
          y = 22,
          width = 34,
          height = 56,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 309,
          name = "start",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
