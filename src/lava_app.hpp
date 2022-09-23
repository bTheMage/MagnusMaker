#pragma once

#include "lava/lava_pipeline.hpp"
#include "lava/lava_window.hpp"
#include "lava/lava_swapchain.hpp"

#include <memory>
#include <vector>
#include <stdexcept>

#ifdef RELEASE
    #define DOMAIN "release"
#else
    #define DOMAIN "debug"
#endif

namespace lava {
    class FirstApp {
        public:
            static constexpr int WIDTH = 800;
            static constexpr int HEIGHT = 600;

            FirstApp ();
            ~FirstApp ();
            void run();

            // DELETING COPY CONSTRUCTORS
            FirstApp(const FirstApp &) = delete;
            FirstApp &operator=(const FirstApp &) = delete;

        private:
            LavaWindow lavaWindow{WIDTH, HEIGHT, "Hello Vulkan!"};
            LavaDevice lavaDevice{lavaWindow};
            LavaSwapChain lavaSwapChain {lavaDevice, lavaWindow.getExtent()};
            std::unique_ptr<LavaPipeline> lavaPipeline;
            VkPipelineLayout pipelineLayout;
            std::vector<VkCommandBuffer> commandBuffers;

            void createPipelineLayout ();
            void createPipeline ();
            void createCommandBuffers ();
            void drawFrame ();


    };
}  // namespace lava