#ifndef SPROUT_OBJECT_HPP
#define SPROUT_OBJECT_HPP

#include <sprout/darkroom.hpp>
#include <sprout/math/constants.hpp>

namespace my_object {
	using namespace sprout::darkroom;
	// object
	static constexpr auto object = objects::make_object_list(
		objects::make_aa_plane(
			objects::aa_plane_direction::y,
			-2.0,
			materials::make_plaid_material_image(
				colors::rgb_f(1.0, 0.0, 0.0), colors::rgb_f(1.0, 1.0, 0.0),
				0.0, 0.0
				)
			),
		objects::make_sphere(
			// central coords(coordinate)
			coords::vector3d(-1.0, 0.5, 7.5),
			2.5, // radius
			materials::make_uniform_material_image(
				colors::rgb_f(0.0, 0.0, 1.0), 0.2
				) // color and alpha
			),
		objects::make_sphere(
			coords::vector3d(1.0, -1.0, 4.0),
			1.0,
			materials::make_uniform_material_image(
				colors::rgb_f(0.0, 1.0, 0.0), 0.2
				)
			),
		objects::make_triangle(
			materials::make_uniform_material_image(
				colors::rgb_f(1.0, 1.0, 0.0), 0.2
				),
			coords::vector3d(-2.0,  0.0, 4.0),
			coords::vector3d( 0.0,  0.0, 4.0),
			coords::vector3d(-1.0, -3.0, 4.0)
			)
		);
	// light
	static constexpr auto light = lights::make_light_list(
		lights::make_point_light(
			coords::vector3d(-3.0, 5.0, 0.0),
			colors::rgb_f(7.0, 7.0, 7.0)
			),
		lights::make_parallel_light(
			coords::vector3d(0.0, 1.0, 0.0),
			colors::rgb_f(0.1, 0.1, 0.1)
			),
		lights::make_parallel_light(
			coords::vector3d(1.0, 0.5, 0.0),
			colors::rgb_f(0.1, 0.1, 0.1)
			),
		lights::make_parallel_light(
			coords::vector3d(-1.0, 0.5, 0.0),
			colors::rgb_f(0.1, 0.1, 0.1)
			),
		lights::make_parallel_light(
			coords::vector3d(0.0, 0.5, 1.0),
			colors::rgb_f(0.1, 0.1, 0.1)
			),
		lights::make_parallel_light(
			coords::vector3d(0.0, 0.5, -1.0),
			colors::rgb_f(0.1, 0.1, 0.1)
			)
		);
	// camera
	static constexpr auto camera = cameras::make_simple_camera(
		sprout::math::root_three<double>() / 2
		);
	// renderer
	static constexpr auto renderer = renderers::make_whitted_style(
		renderers::make_uniform_color(colors::rgb_f(0.0, 0.0, 0.0))
		);
	// raytracer
	static constexpr auto raytracer = tracers::make_raytracer();
}

#endif