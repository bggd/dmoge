module moge.gl;

import moge.handle;

enum GLBackend
{
    undefined = 0,
    ogl,
    d3d11
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

GLBackend getGLBackend() {
  const int i = getBackend();
  assert(i);
  GLBackend backend;
  if (i == GLBackend.ogl) {
    backend = GLBackend.ogl;
  }
  else if (i == GLBackend.d3d11) {
    backend = GLBackend.d3d11;
  }
  assert(backend);
  return backend;
}

unittest {
  auto b = getGLBackend();
  assert(b);
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

private:
int getBackend();
