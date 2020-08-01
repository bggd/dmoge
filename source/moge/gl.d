module moge.gl;

import moge.handle;

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

extern (C++,`moge`) : extern (C++,`gl`) :  // moge::gl
struct InputLayout
{
    const char * glslAttributeName;
    uint glslAttributeLocation;
    const char* hlslSemanticName;
    uint hlslSemanticIndex;
    uint numFloat;
}

struct ShaderDecl
{
    InputLayout* inputArray;
    uint numInput;
    const char* vertexShader;
    const char* pixelShader;
    size_t numByteOfVertexShader;
    size_t numByteOfPixelShader;
}

struct UniformArrayDecl
{
    const char* name;
    ShaderStage stage;
    UniformArrayType type;
    uint numElement;
}

struct TextureDecl
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

struct ContextDecl
{
    uint maxShaders;
    uint maxUniforms;
    uint maxVertexBuffers;
    uint maxTextures;
    void* hwnd;
}

Context createContext(ref ContextDecl decl);
