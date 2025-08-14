using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Color = Microsoft.Xna.Framework.Color;
using Keyboard = Microsoft.Xna.Framework.Input.Keyboard;

namespace TestGameMaui
{
    // All the code in this file is included in all platforms.
    public class TestGame : Game
    {
        private GraphicsDeviceManager _graphics;
        private SpriteBatch? _spriteBatch;

        public TestGame()
        {
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;

            _graphics.PreferredBackBufferWidth = 2560; //1440;
            _graphics.PreferredBackBufferHeight = 1600; //900;
        }

        protected override void Initialize()
        {
            _graphics.ApplyChanges();

            base.Initialize();
        }

        protected override void LoadContent()
        {
            _spriteBatch = new SpriteBatch(GraphicsDevice);

            TestGameResources.LoadTextures(Content);
        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
            {
                //empty
            }

            // TODO: Add your update logic here

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.CornflowerBlue);

            _spriteBatch?.Begin();
            _spriteBatch?.Draw(TestGameResources.GreenBrickTexture, new Vector2(0, 0), Color.White);
            _spriteBatch?.End();

            base.Draw(gameTime);
        }
    }
}
