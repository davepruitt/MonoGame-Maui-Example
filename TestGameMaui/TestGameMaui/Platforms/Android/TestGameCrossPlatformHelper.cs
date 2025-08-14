using Android.Content;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestGameMaui
{
    public partial class TestGameCrossPlatformHelper
    {
        public static partial void LaunchGame()
        {
            var current_activity = Platform.CurrentActivity;
            if (current_activity != null)
            {
                Type t = typeof(TestGameActivity);
                Intent intent = new Intent(current_activity, t);
                current_activity.StartActivityForResult(intent, 0);
            }
        }
    }
}
