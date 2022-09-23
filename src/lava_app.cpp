#include "lava_app.hpp"

namespace lava {

  FirstApp::FirstApp () {
    createPipelineLayout();
    createPipeline();
    createCommandBuffers();
  }

  FirstApp::~FirstApp () {
    vkDestroyPipelineLayout(lavaDevice.device(), pipelineLayout, nullptr);
  }

  void FirstApp::run() {
    while (!lavaWindow.shouldClose()) {
      glfwPollEvents();
    }
  }

  void FirstApp::createPipelineLayout () {
    VkPipelineLayoutCreateInfo pipelineLayoutInfo{};
    pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    pipelineLayoutInfo.setLayoutCount = 0;
    pipelineLayoutInfo.pSetLayouts = nullptr;
    pipelineLayoutInfo.pushConstantRangeCount = 0;
    pipelineLayoutInfo.pPushConstantRanges = nullptr;

    if (VK_SUCCESS != vkCreatePipelineLayout(lavaDevice.device(), &pipelineLayoutInfo, nullptr, &pipelineLayout))
      throw std::runtime_error("Failed to create pipeline layout!");
  }

  void FirstApp::createPipeline () {
    auto pipelineConfig = 
      LavaPipeline::defaultPipelineConfigInfo(lavaSwapChain.width(), lavaSwapChain.height());

    pipelineConfig.renderPass = lavaSwapChain.getRenderPass();
    pipelineConfig.pipelineLayout = pipelineLayout;
    lavaPipeline = std::make_unique<LavaPipeline>(
      lavaDevice,
      "target/" DOMAIN "/spv/vert/simple_shader.vert.spv",
      "target/" DOMAIN "/spv/frag/simple_shader.frag.spv",
      pipelineConfig
    );
  }

  void FirstApp::createCommandBuffers () {

  }

  void FirstApp::drawFrame () {

  }
}  // namespace lava