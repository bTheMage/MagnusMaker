#pragma once

#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#include <string>
namespace lava {

class LavaWindow {
 public:
  LavaWindow(int w, int h, std::string name);
  ~LavaWindow();

  // DELETING DANGEROUS OPERATORS
  LavaWindow(const LavaWindow &) = delete;
  LavaWindow &operator=(const LavaWindow &) = delete;

  bool shouldClose() { return glfwWindowShouldClose(window); }
  VkExtent2D getExtent () { return {static_cast<uint32_t>(width), static_cast<uint32_t>(height)}; }

  void createWindowSurface(VkInstance instance, VkSurfaceKHR *surface);

  int getWidth() { return width; }
  int getHeight() { return height; }

 private:
  void initWindow();

  const int width;
  const int height;

  std::string windowName;
  GLFWwindow *window;
};
}  // namespace lava
