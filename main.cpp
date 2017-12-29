#define SPROUT_CONFIG_SUPPORT_TEMPORARY_CONTAINER_ITERATION

#include <cstddef>
#include <iostream>
#include "sprout_object.hpp"

static constexpr std::size_t total_width = DARKROOM_TOTAL_WIDTH;
static constexpr std::size_t total_height = DARKROOM_TOTAL_HEIGHT;
static constexpr std::size_t tile_width = DARKROOM_TILE_WIDTH;
static constexpr std::size_t tile_height = DARKROOM_TILE_HEIGHT;
static constexpr std::size_t offset_x = DARKROOM_OFFSET_X;
static constexpr std::size_t offset_y = DARKROOM_OFFSET_Y;

int main() {
	using namespace sprout::darkroom;
	using image_type = pixels::color_pixels<tile_width, tile_height>::type;

	static constexpr auto image = pixels::generate<image_type>(
		my_object::raytracer,
		my_object::renderer,
		my_object::camera,
		my_object::object,
		my_object::light,
		offset_x,
		offset_y,
		total_width,
		total_height
	);

	std::cout
		<< "P3" << std::endl
		<< image[0].size() << ' ' << image.size() << std::endl
		<< 255 << std::endl
		;
	for (auto i = image.begin(), last = image.end(); i != last; ++i) {
		auto const& line = *i;
		for (auto j = line.begin(), last = line.end(); j != last; ++j) {
			auto const& pixel = *j;
			std::cout
				<< unsigned(colors::r(pixel)) << ' '
				<< unsigned(colors::g(pixel)) << ' '
				<< unsigned(colors::b(pixel)) << std::endl
				;
		}
	}
}