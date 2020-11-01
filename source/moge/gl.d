module moge.gl;

import moge.handle;

enum GLBackend
{
    undefined = 0,
    d3d11,
    ogl
}

enum ShaderStage
{
    undefined = 0,
    vertex,
    pixel
}

enum UniformArrayType
{
    undefined = 0,
    float4
}

enum TextureFormat
{
    undefined = 0,
    rgba8
}

enum TextureFilter
{
    undefined = 0,
    linear,
    nearest
}

enum DrawPrimitive
{
    undefined = 0,
    triangles
}

private enum MOGE_GL_BACKEND
{
    MOGE_GL_BACKEND_UNDEFINED = 0,
    MOGE_GL_BACKEND_D3D11,
    MOGE_GL_BACKEND_OGL
}

GLBackend getGLBackend()
{
    return cast(GLBackend) getBackend();
}

unittest
{
    auto b = getGLBackend();
    assert(b);
}

void draw(ref Context ctx, DrawPrimitive topology, uint count, ushort offset)
{
    MOGE_GL_DRAW_PRIMITIVE draw_type = cast(MOGE_GL_DRAW_PRIMITIVE) topology;
    draw(ctx, draw_type, count, offset);
}

private enum MOGE_GL_DRAW_PRIMITIVE
{
    MOGE_GL_DRAW_PRIMITIVE_UNDEFINED = 0,
    MOGE_GL_DRAW_PRIMITIVE_TRIANGLES
}

extern(C) alias mogeGLGetProcAddress = void* function(const(char*));

extern (C++,`moge`):
extern (C++,`gl`): // moge::gl
struct InputLayout
{
    const char* glslAttributeName;
    uint glslAttributeLocation;
    const char* hlslSemanticName;
    uint hlslSemanticIndex;
    uint numFloat;
}

struct ShaderDesc
{
    InputLayout* inputArray;
    uint numInput;
    const char* vertexShader;
    const char* pixelShader;
    size_t numByteOfVertexShader;
    size_t numByteOfPixelShader;
}

struct UniformArrayDesc
{
    const char* name;
    ShaderStage stage;
    UniformArrayType type;
    uint numElement;
}

struct TextureDesc
{
    const char* data;
    uint width;
    uint height;
    TextureFormat imageFormat;
    TextureFilter minFilter;
    TextureFilter maxFilter;
}

struct Shader
{
    Handle handle;
}

struct UniformArray
{
    Handle handle;
}

struct VertexBuffer
{
    Handle handle;
}

struct Texture
{
    Handle handle;
}

struct Context
{
    struct ContextImpl;
    ContextImpl* pimpl;
}

struct ContextDesc
{
    uint maxShaders;
    uint maxUniformArrays;
    uint maxVertexBuffers;
    uint maxTextures;
    void* hwnd;
}

void loadOGL(mogeGLGetProcAddress getProcAddress);

Context createContext(ref ContextDesc);
void destroyContext(ref Context);
void resizeBackBuffer(ref Context);
Shader createShader(ref Context, ref ShaderDesc);
void destroyShader(ref Context, ref Shader);
UniformArray createUniformArray(ref Context, ref UniformArrayDesc);
void destroyUniformArray(ref Context, ref UniformArray);
void updateUniformArray(ref Context, ref UniformArray, const(void*) data, size_t num_bytes);
VertexBuffer createVertexBuffer(ref Context, uint num_bytes);
void destroyVertexBuffer(ref Context, ref VertexBuffer);
void updateVertexBuffer(ref Context, ref VertexBuffer, const(void*) vertices, size_t num_bytes);
Texture createTexture(ref Context, ref TextureDesc);
void destroyTexture(ref Context, ref Texture);

void clear(ref Context, float R, float G, float B, float A);
void present(ref Context);
void setShader(ref Context, ref Shader);
void setUniformArray(ref Context, ref UniformArray);
void setTexture(ref Context, ref Texture);
void setVertexBuffer(ref Context, ref VertexBuffer);

private:
MOGE_GL_BACKEND getBackend();
void draw(ref Context ctx, MOGE_GL_DRAW_PRIMITIVE topology, uint count, ushort offset);
