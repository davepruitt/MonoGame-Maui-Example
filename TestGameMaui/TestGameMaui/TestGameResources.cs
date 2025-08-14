using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestGameMaui
{
    public static class TestGameResources
    {
        public static string? GreenBrickTextureName = "03-Breakout-Tiles";
        public static Texture2D? GreenBrickTexture;

        public static void LoadTextures (ContentManager? content)
        {
            //Load the green brick texture
            GreenBrickTexture = content?.Load<Texture2D?>(GreenBrickTextureName);
        }
    }
}
