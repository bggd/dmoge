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

GLBackend getGLBackend()
{
    const int i = getBackend();
    assert(i);
    return cast(GLBackend) i;
}

unittest
{
    auto b = getGLBackend();
    assert(b);
}

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

Context createContext(ref ContextDesc desc);
void destroyContext(ref Context ctx);
void resizeBackBuffer(ref Context ctx);
Shader createShader(ref Context ctx, ref ShaderDesc desc);
void destroyShader(ref Context ctx, ref Shader shdr);
UniformArray createUniformArray(ref Context ctx, ref UniformArrayDesc desc);
void destroyUniformArray(ref Context ctx, ref UniformArray);
void updateUniformArray(ref Context ctx, ref UniformArray uary, const(void*) data, size_t num_bytes);
VertexBuffer createVertexBuffer(ref Context ctx, uint num_bytes);
void destroyVertexBuffer(ref Context ctx, ref VertexBuffer vbo);
void updateVertexBuffer(ref Context ctx, ref VertexBuffer vbo,
        const(void*) vertices, size_t num_bytes);
Texture createTexture(ref Context ctx, ref TextureDesc desc);
void destroyTexture(ref Context ctx, ref Texture tex);

private:
int getBackend();
