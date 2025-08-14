using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestGameMaui
{
    public partial class TestGameCrossPlatformHelper
    {
        static private TestGame? _game;

        public static partial void LaunchGame()
        {
            if (_game == null)
            {
                _game = new TestGame();
            }

            _game.Run();
        }
    }
}
