module moge.app.main_loop;

import bindbc.sdl;

struct MainLoopConfig
{
    string windowTitle;
    int windowWidth;
    int windowHeight;
}

class MainLoop
{

    SDL_Window* window;
    bool isRunning;

    void init(ref MainLoopConfig config)
    {
        assert(this.window == null);
        assert(this.isRunning == false);

        SDLSupport ret = loadSDL();
        assert(ret == sdlSupport, "SDL2(dynamic library) is not found");

        int err = SDL_Init(SDL_INIT_EVERYTHING);
        assert(err == 0);

        this.window = SDL_CreateWindow(config.windowTitle.ptr ? config.windowTitle.ptr : "dmoge", SDL_WINDOWPOS_UNDEFINED,
                SDL_WINDOWPOS_UNDEFINED, config.windowWidth,
                config.windowHeight, SDL_WINDOW_SHOWN);
        assert(this.window);

        this.isRunning = true;

        this.onInit();
    }

    void shutdown()
    {
        assert(this.isRunning == false);
        assert(this.window);

        this.onShutdown();

        SDL_DestroyWindow(this.window);
        this.window = null;
        SDL_Quit();
    }

    void* getHWND()
    {
        assert(this.isRunning);
        assert(this.window);
        SDL_SysWMinfo si;
        SDL_bool b = SDL_GetWindowWMInfo(this.window, &si);
        assert(b == SDL_TRUE);
        if (si.subsystem == SDL_SYSWM_WINDOWS)
        {
            return si.info.win.window;
        }
        else
        {
            return null;
        }
    }

    void pollEvents()
    {
        assert(this.isRunning);
        assert(this.window);

        SDL_Event ev;
        while (this.isRunning && SDL_PollEvent(&ev))
        {
            switch (ev.type)
            {
            case SDL_QUIT:
                this.onCloseRequested();
                this.isRunning = false;
                break;
            default:
                break;
            }
        }
    }

    void onInit()
    {
    }

    void onShutdown()
    {
    }

    void onUpdate()
    {
    }

    void onCloseRequested()
    {
    }
}

unittest
{
    class App : MainLoop
    {
    }

    MainLoop mainloop = new App();

    MainLoopConfig config;
    mainloop.init(config);

    version (Windows)
    {
        assert(mainloop.getHWND());
    }
    else
    {
        assert(mainloop.getHWND() == null);
    }
    mainloop.pollEvents();
    mainloop.isRunning = false;
    mainloop.shutdown();
}
