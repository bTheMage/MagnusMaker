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
			drawFrame();
		}

		vkDeviceWaitIdle(lavaDevice.device());
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
		commandBuffers.resize(lavaSwapChain.imageCount());

		VkCommandBufferAllocateInfo allocInfo {};
		allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
		allocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		allocInfo.commandPool = lavaDevice.getCommandPool();

		allocInfo.commandBufferCount = static_cast<uint32_t>(commandBuffers.size());

		if (VK_SUCCESS != 
			vkAllocateCommandBuffers(lavaDevice.device(), &allocInfo, commandBuffers.data())
		) throw std::runtime_error("failed to allocate command buffers.");

		for (int i = 0; i < commandBuffers.size(); i++) {
			VkCommandBufferBeginInfo beginInfo {};
			beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;

			if (VK_SUCCESS != vkBeginCommandBuffer(commandBuffers[i], &beginInfo))
				throw std::runtime_error("failed to beging recording command buffer.");

			VkRenderPassBeginInfo renderPassInfo {};
			renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
			renderPassInfo.renderPass = lavaSwapChain.getRenderPass();
			renderPassInfo.framebuffer = lavaSwapChain.getFrameBuffer(i);

			renderPassInfo.renderArea.offset = {0, 0};
			renderPassInfo.renderArea.extent = lavaSwapChain.getSwapChainExtent();

			std::array<VkClearValue, 2> clearValues{};
			clearValues[0].color = {0.1f, 0.1f, 0.1f, 1.0f};
			clearValues[1].depthStencil = {1.0f, 0};
			
			renderPassInfo.clearValueCount = static_cast<uint32_t>(clearValues.size());
			renderPassInfo.pClearValues = clearValues.data();

			vkCmdBeginRenderPass(commandBuffers[i], &renderPassInfo, VK_SUBPASS_CONTENTS_INLINE);

			lavaPipeline->bind(commandBuffers[i]);
			vkCmdDraw(commandBuffers[i], 3, 1, 0, 0);

			vkCmdEndRenderPass(commandBuffers[i]);
			if (VK_SUCCESS != vkEndCommandBuffer(commandBuffers[i]))
				throw std::runtime_error("failed to record command buffer.");
		}
	}
	
	void FirstApp::drawFrame () {
		uint32_t imageIndex;
		auto result = lavaSwapChain.acquireNextImage(&imageIndex);

		if (VK_SUCCESS != result && result != VK_SUBOPTIMAL_KHR)
			throw std::runtime_error("failed to acquire swap chain image.");

		result = lavaSwapChain.submitCommandBuffers(&commandBuffers[imageIndex], &imageIndex);

		if (VK_SUCCESS != result) throw std::runtime_error("failed to present swap chain image.");

	}
} // namespace lava