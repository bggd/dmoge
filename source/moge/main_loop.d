module moge.main_loop;

import bindbc.sdl;
import gl = moge.gl;

struct MainLoopConfig
{
    string windowTitle;
    int windowWidth;
    int windowHeight;
}

class MainLoop
{

    SDL_Window* window;
    SDL_GLContext windowGLCtx;
    bool isRunning;

    void init(ref MainLoopConfig config)
    {
        assert(this.window == null);
        assert(this.windowGLCtx == null);
        assert(this.isRunning == false);

        SDLSupport ret = loadSDL();
        assert(ret == sdlSupport, "SDL2(dynamic library) is not found");

        int err = SDL_Init(SDL_INIT_EVERYTHING);
        assert(err == 0);

        const char* title = config.windowTitle.ptr ? config.windowTitle.ptr : "dmoge";
        SDL_WindowFlags flags = SDL_WINDOW_SHOWN;
        if (gl.getGLBackend() == gl.GLBackend.ogl)
        {
            flags |= SDL_WINDOW_OPENGL;
        }

        this.window = SDL_CreateWindow(title, SDL_WINDOWPOS_UNDEFINED,
                SDL_WINDOWPOS_UNDEFINED, config.windowWidth, config.windowHeight, flags);
        assert(this.window, "SDL_CreateWindow is failed");

        if (gl.getGLBackend() == gl.GLBackend.ogl)
        {
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
            SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
            SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

            this.windowGLCtx = SDL_GL_CreateContext(this.window);
            assert(this.windowGLCtx, "SDL_GL_CreateContext is failed");

            err = SDL_GL_MakeCurrent(this.window, this.windowGLCtx);
            assert(err == 0);
        }

        this.isRunning = true;

        this.onInit();
    }

    void shutdown()
    {
        assert(this.isRunning == false);
        assert(this.window);

        this.onShutdown();

        if (gl.getGLBackend() == gl.GLBackend.ogl)
        {
            assert(this.windowGLCtx);
            SDL_GL_DeleteContext(this.windowGLCtx);
            this.windowGLCtx = null;
        }

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
